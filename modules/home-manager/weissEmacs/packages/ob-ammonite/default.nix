{ trivialBuild, s, scala-mode, xterm-color, ... }:
trivialBuild rec {
  pname = "ob-ammonite";
  version = "0.1";
  src = ./.;
  propagatedUserEnvPkgs = [ s scala-mode xterm-color ];
  buildInputs = propagatedUserEnvPkgs;
}
