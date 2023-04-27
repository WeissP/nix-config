{ lib, stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
  pname = "thumbfast";
  version = "26042023";

  src = fetchFromGitHub {
    owner = "po5";
    repo = pname;
    rev = "b913ab503d02b4fd92688bd1977a1b524ad22758";
    sha256 = "sha256-iiARrOUCnrx0yOcYQZMIZc46cxbi/JiMdCjRwQGkOLg=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/mpv/scripts
    cp thumbfast.lua $out/share/mpv/scripts
    runHook postInstall
  '';

  passthru.scriptName = "thumbfast.lua";

  meta = with lib; {
    description = "High-performance on-the-fly thumbnailer for mpv";
    homepage = "https://github.com/po5/thumbfast";
    license = licenses.unlicense;
    platforms = platforms.all;
  };
}
