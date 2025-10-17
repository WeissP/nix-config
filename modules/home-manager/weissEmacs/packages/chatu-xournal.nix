{ trivialBuild, fetchFromGitHub, deps }:
trivialBuild rec {
  pname = "chatu-xournal";
  version = "16bd3b6763639dd5e4abd1365204668ef50c4291";
  propagatedUserEnvPkgs = with deps; [ f chatu ];
  buildInputs = propagatedUserEnvPkgs;
  src = (fetchFromGitHub {
    owner = "WeissP";
    repo = "chatu-xournal";
    rev = version;
    hash = "sha256-YOQxFIev6hBy/BqTKiDV7FSy31TJpz1VqC4QdORYTGM=";
  });
}

