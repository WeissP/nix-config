{
  pkgs,
  myEnv,
  myLib,
  lib,
  secrets,
  configSession,
  ...
}:
with myEnv;
{
  home.file."${homeDir}/projects/ariang.html".source =
    let
      s = pkgs.fetchzip {
        url = "https://github.com/mayswind/AriaNg/releases/download/1.3.7/AriaNg-1.3.7-AllInOne.zip";
        sha256 = "sha256-SPpBk5fPJD81sgPggESBuKZlXiSHS+vp3vZT5Hfvc5Y=";
        stripRoot = false;
      };
    in
    "${s}/index.html";
}
