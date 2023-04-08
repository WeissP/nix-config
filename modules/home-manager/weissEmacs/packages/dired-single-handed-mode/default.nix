{ trivialBuild, dired-filter, hydra }:
trivialBuild rec {
  pname = "dired-single-handed-mode";
  version = "0.1";
  src = ./.;
  propagatedUserEnvPkgs = [ dired-filter hydra ];
  buildInputs = propagatedUserEnvPkgs;
}
