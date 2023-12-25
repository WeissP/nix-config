{ trivialBuild, fetchFromGitHub, scala-mode, s, xterm-color }:
trivialBuild rec {
  pname = "scala-cli-repl";
  version = "c4b2660ccdaf03e1fef9cc669a49f3fd96aa91d8";
  propagatedUserEnvPkgs = [ scala-mode s xterm-color ];
  buildInputs = propagatedUserEnvPkgs;
  src = (fetchFromGitHub {
    owner = "ag91";
    repo = "scala-cli-repl";
    rev = version;
    hash = "sha256-4YpHiEbErgtmQXMp2NvswhVcOw9d6q3jgRVXTldzwXM=";
  });
}
