{ trivialBuild, fetchFromGitHub, deps }:
trivialBuild rec {
  pname = "chatu-xournal";
  version = "fe7babc41aefb664fbaa58d6c0e3d2e8af979dcd";
  propagatedUserEnvPkgs = with deps; [ f chatu ];
  buildInputs = propagatedUserEnvPkgs;
  src = (fetchFromGitHub {
    owner = "WeissP";
    repo = "chatu-xournal";
    rev = version;
    hash = "sha256-X9D6YSmudwAxr7aIhsLetSIi0xhbADrvaNO9QIoZpLs=";
  });
}

