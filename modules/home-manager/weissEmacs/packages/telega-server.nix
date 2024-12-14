{
  pkg-config,
  stdenv,
  fetchFromGitHub,
  system,
  ...
}:

let
  repo = fetchFromGitHub {
    owner = "zevlg";
    repo = "telega.el";
    rev = "v0.8.0";
    sha256 = "sha256-2hXXtBOv+2KN3IztrsvD05Ey/jMHmGM7YTum0exGdzo=";
  };
  tdlib =
    (import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/f76bef61369be38a10c7a1aa718782a60340d9ff.tar.gz";

      sha256 = "sha256:01zjqwj1m7qipc4x9gakffi9k8rk5mjk159p20xh1pfil19m82p4";
    }) { inherit system; }).tdlib;
in
stdenv.mkDerivation {
  pname = "telega-server";
  version = "1.8.0";

  src = repo + "/server";

  buildInputs = [ tdlib ];
  nativeBuildInputs = [ pkg-config ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    install -m755 -Dt $out/bin ./telega-server
  '';
}
