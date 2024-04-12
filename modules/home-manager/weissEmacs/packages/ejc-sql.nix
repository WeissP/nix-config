{ trivialBuild, fetchFromGitLab, deps }:
trivialBuild rec {
  pname = "ejc-sql";
  version = "87862cbc4b5c7753a3041f0346d4ada5935ab7b2";
  propagatedUserEnvPkgs = with deps; [ ];
  buildInputs = propagatedUserEnvPkgs;
  src = (fetchFromGitLab {
    owner = "kostafey";
    repo = "ejc-sql";
    rev = version;
    hash = "sha256-5J8468+4z+X4ZiNjxFnYD+mRx9UfTh8FEYrUfICAXfA=";
  });
}
