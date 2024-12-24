{
  trivialBuild,
  fetchFromGitHub,
  deps,
}:
trivialBuild rec {
  pname = "consult";
  version = "1.8";
  propagatedUserEnvPkgs = with deps; [
    compat
  ];
  buildInputs = propagatedUserEnvPkgs;
  src = (
    fetchFromGitHub {
      owner = "minad";
      repo = "consult";
      rev = version;
      hash = "sha256-L8M81rLgjYTDE6aYMxCMSa0LUuaATQ8RJ3ffp3ifTBo=";
    }
  );
}
