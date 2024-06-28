{ trivialBuild, fetchFromGitHub, deps }:
trivialBuild rec {
  pname = "eglot-booster";
  version = "e19dd7ea81bada84c66e8bdd121408d9c0761fe6";
  propagatedUserEnvPkgs = with deps; [ eglot jsonrpc ];
  buildInputs = propagatedUserEnvPkgs;
  src = (fetchFromGitHub {
    owner = "jdtsmith";
    repo = "eglot-booster";
    rev = version;
    hash = "sha256-vF34ZoUUj8RENyH9OeKGSPk34G6KXZhEZozQKEcRNhs=";
  });
}

