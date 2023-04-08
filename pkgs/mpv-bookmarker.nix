{ lib, stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
  pname = "mpv-bookmarker";
  version = "v1.3.1";

  src = fetchFromGitHub {
    owner = "NurioHin";
    repo = pname;
    rev = version;
    sha256 = "sha256-hGqYIllKXJYQpUw5zEs81U0zHg8SOftdSczQ15BmJd4=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/mpv/scripts
    cp bookmarker-menu.lua $out/share/mpv/scripts
    runHook postInstall
  '';

  passthru.scriptName = "bookmarker-menu.lua";

  meta = with lib; {
    description = "A bookmarker menu to manage all your bookmarks in MPV";
    homepage = "https://github.com/NurioHin/mpv-bookmarker";
    license = licenses.unlicense;
    platforms = platforms.all;
  };
}
