{ trivialBuild, fetchFromGitHub, deps }:
trivialBuild rec {
  pname = "chatu-xournal";
  version = "c963bcba296a89c4f0feb1f22ebda50b6bf32b33";
  propagatedUserEnvPkgs = with deps; [ f chatu ];
  buildInputs = propagatedUserEnvPkgs;
  src = (fetchFromGitHub {
    owner = "WeissP";
    repo = "chatu-xournal";
    rev = version;
    hash = "sha256-k5k6Gw6dio8MP2+gqsnnH+n/QNbowqOnUe5P9T9ey+Q=";
  });
}

