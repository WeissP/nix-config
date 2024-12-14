{
  lib,
  pkgs,
  myNixRepo,
  ...
}:
with lib;
rec {
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
  genEnv =
    env: with env; rec {
      ifDarwin = optionalAttrs (arch == "darwin");
      ifLinux = optionalAttrs (arch == "linux");
      ifPersonal = optionalAttrs (builtins.elem "personal" usage);
      ifRemoteServer = optionalAttrs (builtins.elem "remote-server" usage);
      ifLocalServer = optionalAttrs (builtins.elem "local-server" usage);
      ifRouter = optionalAttrs (builtins.elem "router" usage);
      ifServer = optionalAttrs (
        builtins.elem "local-server" usage || builtins.elem "remote-server" usage
      );
      ifLinuxPersonal = optionalAttrs (arch == "linux" && builtins.elem "personal" usage);
      ifDarwinPersonal = optionalAttrs (arch == "darwin" && builtins.elem "personal" usage);
      username = env.username;
      arch = env.arch;
      usage = env.usage;
      homeDir = if (arch == "darwin") then "/Users/${username}" else "/home/${username}";
      nixDir = "${homeDir}/nix-config";
      scriptsDir = "${homeDir}/scripts";
      financeDir = "${homeDir}/finance";
      singboxCfgDir = "${homeDir}/.config/singbox_config";
      systemBin = binary: if arch == "linux" then "/run/current-system/sw/bin/${binary}" else binary;
      userBin = binary: "/etc/profiles/per-user/${username}/bin/${binary}";
      ensurePsqlDb =
        dbName:
        service.startup {
          cmds = "${scriptsDir}/ensure_psql_db.sh ${dbName}";
          description = "ensure PostgreSQL database ${dbName}";
        };
    };
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
  service = {
    startup =
      {
        cmds,
        description ? "STARTUP",
        wantedBy ? [ "default.target" ],
        Environment ? "",
      }:
      {
        Unit.Description = description;
        Install.WantedBy = wantedBy;
        Service = {
          Type = "simple";
          ExecStart = cmds;
          Environment = Environment;
        };
      };
  };
}
