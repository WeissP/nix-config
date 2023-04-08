{ trivialBuild }:
trivialBuild rec {
  pname = "org-table-to-qmk-keymap";
  version = "0.1";
  src = ./.;
  # propagatedUserEnvPkgs = [ vertico ];
  # buildInputs = propagatedUserEnvPkgs;
}
