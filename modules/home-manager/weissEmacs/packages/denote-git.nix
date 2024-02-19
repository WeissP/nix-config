{ trivialBuild, fetchFromGitHub }:
trivialBuild rec {
  pname = "denote";
  version = "69709f8e8a3c2f2016173ac5e6ff52484a8f621e";
  propagatedUserEnvPkgs = [ ];
  buildInputs = propagatedUserEnvPkgs;
  src = (fetchFromGitHub {
    owner = "protesilaos";
    repo = "denote";
    rev = version;
    hash = "sha256-00K+hGAfmhfCBBcMcKattsg5l47KLI03clpbmNGzX2s=";
  });
}
