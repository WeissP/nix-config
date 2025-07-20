{
  lib,
  myNixRepo,
  ...
}:
with lib;
rec {
  quote = s: ''"${s}"'';
  expandEnv =
    args:
    with args;
    args
    // rec {
      ifDisplay = optionalAttrs (display != "none");
      ifXorg = optionalAttrs (display == "Xorg");
      ifWayland = optionalAttrs (display == "wayland");
      ifDarwin = optionalAttrs (arch == "darwin");
      ifLinux = optionalAttrs (arch == "linux");
      ifUsage = u: optionalAttrs (builtins.elem u usage);
      ifPersonal = ifUsage "personal";
      ifRemoteServer = ifUsage "remote-server";
      ifLocalServer = ifUsage "local-server";
      ifRouter = ifUsage "router";
      ifServer = optionalAttrs (
        builtins.elem "local-server" usage || builtins.elem "remote-server" usage
      );
      ifHomeServer = optionalAttrs (configSession == "homeServer");
      ifDesktop = optionalAttrs (configSession == "desktop");
      ifLinuxPersonal = optionalAttrs (arch == "linux" && builtins.elem "personal" usage);
      ifLinuxDaily = optionalAttrs (arch == "linux" && builtins.elem "daily" usage);
      ifDarwinPersonal = optionalAttrs (arch == "darwin" && builtins.elem "personal" usage);
      homeDir = if (arch == "darwin") then "/Users/${username}" else "/home/${username}";
      nixDir = "${homeDir}/nix-config";
      scriptsDir = "${homeDir}/scripts";
      financeDir = "${homeDir}/finance";
      singboxCfgDir = "${homeDir}/.config/singbox_config";
      systemBin = binary: if arch == "linux" then "/run/current-system/sw/bin/${binary}" else binary;
      userBin = binary: "/etc/profiles/per-user/${username}/bin/${binary}";
      ensurePsqlDb = dbName: {
        Unit.Description = "ensure PostgreSQL database ${dbName}";
        Install.WantedBy = [ "default.target" ];
        Service = {
          Type = "simple";
          ExecStart = "${scriptsDir}/ensure_psql_db.sh ${dbName}";
        };
      };
    };
  validateEnv =
    args:
    builtins.hasAttr "location" args
    && (builtins.hasAttr "configSession" args)
    && (lib.assertOneOf "location" args.location [
      "home"
      "china"
      "japan"
      "uni"
    ])
    && (lib.assertOneOf "display" args.display [
      "Xorg"
      "wayland"
      "none"
    ]);

  resource = path: myNixRepo + "/resources/" + path;
  withConfigDir = path: ../home-manager/common/config_files + path;
  mkFont =
    { stdenv, unzip }:
    fontName: path:
    stdenv.mkDerivation {
      nativeBuildInputs = [ unzip ];

      name = fontName;
      src = resource path;
      sourceRoot = ".";

      installPhase = ''
        DEST="$out/share/fonts/${fontName}"
        mkdir -p "$DEST"
        find . \( -name '*.ttf' -o -name '*.otf' \) -print0 | xargs -0 cp -t "$DEST"
      '';
    };

  mergeAttrList = lists.foldr (elem: res: trivial.mergeAttrs elem res) { };
  interval = {
    minutes = m: filter (t: trivial.mod t m == 0) (range 1 59);
  };
  mkNuBinPath =
    packages:
    let
      bins = builtins.replaceStrings [ ":" ] [ "," ] (lib.makeBinPath packages);
    in
    "[${bins}]";
  service = {
    startup =
      {
        binName,
        username,
        wantedBy ? [ "autostart.target" ],
        service ? { },
      }:
      {
        Unit.Description = "startup ${binName}";
        Install.WantedBy = wantedBy;
        Service = {
          Type = "simple";
          PassEnvironment = "PATH";
          KillMode = "process";
          ExecStart = "/etc/profiles/per-user/${username}/bin/${binName}";
        } // service;
      };
  };
  toBase64 =
    text:
    let
      inherit (lib)
        sublist
        mod
        stringToCharacters
        concatMapStrings
        ;
      inherit (lib.strings) charToInt;
      inherit (builtins)
        substring
        foldl'
        genList
        elemAt
        length
        concatStringsSep
        stringLength
        ;
      lookup = stringToCharacters "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
      sliceN =
        size: list: n:
        sublist (n * size) size list;
      pows = [
        (64 * 64 * 64)
        (64 * 64)
        64
        1
      ];
      intSextets = i: map (j: mod (i / j) 64) pows;
      compose =
        f: g: x:
        f (g x);
      intToChar = elemAt lookup;
      convertTripletInt = sliceInt: concatMapStrings intToChar (intSextets sliceInt);
      sliceToInt = foldl' (acc: val: acc * 256 + val) 0;
      convertTriplet = compose convertTripletInt sliceToInt;
      join = concatStringsSep "";
      convertLastSlice =
        slice:
        let
          len = length slice;
        in
        if len == 1 then
          (substring 0 2 (convertTripletInt ((sliceToInt slice) * 256 * 256))) + "=="
        else if len == 2 then
          (substring 0 3 (convertTripletInt ((sliceToInt slice) * 256))) + "="
        else
          "";
      len = stringLength text;
      nFullSlices = len / 3;
      bytes = map charToInt (stringToCharacters text);
      tripletAt = sliceN 3 bytes;
      head = genList (compose convertTriplet tripletAt) nFullSlices;
      tail = convertLastSlice (tripletAt nFullSlices);
    in
    join (head ++ [ tail ]);
}
