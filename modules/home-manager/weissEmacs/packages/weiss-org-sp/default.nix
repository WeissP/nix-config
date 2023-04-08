{ trivialBuild }:
trivialBuild rec {
  pname = "weiss-org-sp";
  version = "0.1";
  src = ./.;
  # propagatedUserEnvPkgs = [ vertico ];
  # buildInputs = propagatedUserEnvPkgs;
}
