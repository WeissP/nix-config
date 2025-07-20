{
  inputs,
  outputs,
  myEnv,
  lib,
  config,
  pkgs,
  username,
  secrets,
  myLib,
  ...
}:
{
  imports = [
    ./minimum.nix
    ./webman.nix
    ./shell
    ./aria.nix
    ./videosDownloader.nix
    ./gtrash.nix
    ./ytdl-sub.nix
    ./yutto.nix
  ];

  config = {
    home.packages = with pkgs; [
      dua
      lux
      (pkgs.additions.writeNuBinWithConfig "crop_fanart"
        {
          env = {
            Path =
              with pkgs;
              myLib.mkNuBinPath [
                imagemagick
              ];
          };
        }
        ''
          export def main [key: string] {
            let dir = glob ($"**/*\(?i)($key)*" | into glob) --no-file | first
            cd $dir
            magick "fanart.jpg" -gravity east -crop 534:800 +repage poster.jpg  
          }
        ''
      )
    ];

    systemd.user.services.notes-server = {
      Unit = {
        Description = "File server for notes";
        After = [ "network.target" ];
      };
      Service = {
        ExecStart = "${lib.getExe pkgs.dufs} /home/${myEnv.username}/Documents/notes-export/ --allow-search --enable-cors";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
