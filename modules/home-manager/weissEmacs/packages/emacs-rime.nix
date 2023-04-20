{ trivialBuild, fetchFromGitHub, dash, cl-lib, popup, posframe }:
trivialBuild rec {
  pname = "rime";
  version = "v1.0.5";
  propagatedUserEnvPkgs = [ dash cl-lib popup posframe ];
  buildInputs = propagatedUserEnvPkgs;
  src = (fetchFromGitHub {
    owner = "DogLooksGood";
    repo = "emacs-rime";
    rev = "v1.0.5";
    hash = "sha256-Z4hGsXwWDXZie/8IALhyoH/eOVfzhbL69OiJlLHmEXw";
  });
}

