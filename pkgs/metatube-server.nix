{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
}:

pkgs.stdenv.mkDerivation rec {
  pname = "metatube-server";
  version = "1.3.1";

  src = pkgs.fetchurl {
    url = "https://github.com/metatube-community/metatube-server-releases/releases/download/v${version}/metatube-server-linux-amd64-v3.zip";
    sha256 = "sha256-eDJO3iccBw9Qa402f5qD8lzWWGk2v1rAwN6DFNIfIEY=";
  };

  unpackPhase = ''
    runHook preUnpack
    unzip $src
    runHook postUnpack
  '';

  nativeBuildInputs = [ pkgs.unzip ];

  installPhase = ''
    runHook preInstall

    install -d $out/bin
    install -m 755 metatube-server-linux-amd64-v3 $out/bin/metatube-server

    runHook postInstall
  '';

  meta = with lib; {
    description = "A server for MetaTube";
    homepage = "https://github.com/metatube-community/metatube-server";
    license = licenses.unfree; # No license specified
    mainProgram = "metatube-server";
    # platforms = platforms.all.x86_64-linux;
  };
}
