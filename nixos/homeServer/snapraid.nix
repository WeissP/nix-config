{
  config,
  lib,
  pkgs,
  myEnv,
  ...
}:
let
  getSortedAttrNames = attrSet: lib.lists.sortOn lib.id (lib.attrNames attrSet);
in
{
  services.snapraid = {
    enable = true;

    dataDisks = lib.listToAttrs (
      lib.imap1 (index: originalDiskName: {
        name = "d${toString index}";
        value = "/mnt/media/${originalDiskName}";
      }) (getSortedAttrNames myEnv.hddMediaArray)
    );

    parityFiles = lib.imap1 (
      index: diskKey:
      let
        parityFileName = if index == 1 then "snapraid.parity" else "snapraid.${toString index}-parity";
      in
      "/mnt/media/${diskKey}/${parityFileName}"
    ) (getSortedAttrNames myEnv.hddMediaParityArray);

    contentFiles =
      [
        "/var/snapraid.content"
      ]
      ++ (lib.mapAttrsToList (
        diskName: _: "/mnt/media/${diskName}/snapraid.content"
      ) myEnv.hddMediaArray);

    exclude = [
      "*.bak"
      "*.tmp"
      "~*"
      "lost+found/"
      "/lost+found/"
      "System Volume Information/"
      "$RECYCLE.BIN/"
      ".DS_Store"
      "Thumbs.db"
      "*.unrecoverable"
    ];

    extraConfig = ''
      autosave 500
    '';
  };
}
