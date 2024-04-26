{ trivialBuild, fetchFromGitLab, deps }:
trivialBuild rec {
  pname = "chatu";
  version = "c09bd8b99d36c355d632b85ecbffb3b275802381";
  propagatedUserEnvPkgs = with deps; [ f s ];
  buildInputs = propagatedUserEnvPkgs;
  src = (fetchFromGitLab {
    owner = "vherrmann";
    repo = "org-xournalpp";
    rev = version;
    hash = "sha256-c0AYWMkBb7wdl7SWTffjWSXwXbq1PGov2vT8A1pdqpQ=";
  });
}

