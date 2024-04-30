{ trivialBuild, fetchFromGitHub, deps }:
trivialBuild rec {
  pname = "chatu-xournal";
  version = "691d9910a188b43de39bf4f6c6fd81c5bd40c89f";
  propagatedUserEnvPkgs = with deps; [ f chatu ];
  buildInputs = propagatedUserEnvPkgs;
  src = (fetchFromGitHub {
    owner = "WeissP";
    repo = "chatu-xournal";
    rev = version;
    hash = "sha256-LScCxt55LyS4FPEShxiN2cAz3wksNEN4JHqd7OExlW8=";
  });
}

