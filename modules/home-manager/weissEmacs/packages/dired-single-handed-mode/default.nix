{ trivialBuild, dired-filter, hydra, modus-themes }:
trivialBuild rec {
  pname = "dired-single-handed-mode";
  version = "0.1";
  src = ./.;
  propagatedUserEnvPkgs = [ dired-filter hydra modus-themes ];
  buildInputs = propagatedUserEnvPkgs;
}
