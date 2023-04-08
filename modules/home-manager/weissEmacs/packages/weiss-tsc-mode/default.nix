{ trivialBuild, dash, tree-sitter, tree-sitter-langs, s }:
trivialBuild rec {
  pname = "weiss-tsc-mode";
  version = "0.1";
  src = ./.;
  propagatedUserEnvPkgs = [ dash tree-sitter tree-sitter-langs s ];
  buildInputs = propagatedUserEnvPkgs;
}
