{ trivialBuild, scala-mode, s, ... }:
trivialBuild rec {
  pname = "ammonite-term-repl";
  version = "0.1";
  src = ./.;
  propagatedUserEnvPkgs = [ scala-mode s ];
  buildInputs = propagatedUserEnvPkgs;
}
