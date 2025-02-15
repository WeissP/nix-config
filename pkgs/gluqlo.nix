{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation {
  pname = "gluqlo";
  version = "1.0";

  src = pkgs.fetchFromGitHub {
    owner = "alexanderk23";
    repo = "gluqlo";
    rev = "master";
    sha256 = "sha256-bPRmMQnStPNQsR3l3N7k12Qj+Sf+e8HjhG4ihrqXr0I=";
  };

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = with pkgs.lts; [
    SDL
    SDL_gfx
    SDL_ttf
    xorg.libX11
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  installPhase = ''
    mkdir -p $out/bin
    install -m755 gluqlo $out/bin/
  '';

  meta = with pkgs.lib; {
    description = "Fliqlo screensaver clone for Linux";
    homepage = "https://github.com/alexanderk23/gluqlo";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
