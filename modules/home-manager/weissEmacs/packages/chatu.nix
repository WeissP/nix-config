{ trivialBuild, fetchFromGitHub, deps }:
trivialBuild rec {
  pname = "chatu";
  version = "0bc98ca7f9665a04c5c9d8c3152a98bf04933f0c";
  propagatedUserEnvPkgs = with deps; [ plantuml-mode ];
  buildInputs = propagatedUserEnvPkgs;
  src = (fetchFromGitHub {
    owner = "kimim";
    repo = "chatu";
    rev = version;
    hash = "sha256-CrHWq62XsS1AKTD27MCml3/xzn9F1ZGcF7aaZQ7iYOo=";
  });
}

