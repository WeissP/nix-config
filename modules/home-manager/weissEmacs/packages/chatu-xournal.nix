{ trivialBuild, fetchFromGitHub, deps }:
trivialBuild rec {
  pname = "chatu-xournal";
  version = "cc70817275e982a4c05d7b8c2a262571d37c4121";
  propagatedUserEnvPkgs = with deps; [ f chatu ];
  buildInputs = propagatedUserEnvPkgs;
  src = (fetchFromGitHub {
    owner = "WeissP";
    repo = "chatu-xournal";
    rev = version;
    # hash = "sha256-CrHWq62XsS1AKTD27MCml3/xzn9F1ZGcF7aaZQ7iYOo=";
  });
}

