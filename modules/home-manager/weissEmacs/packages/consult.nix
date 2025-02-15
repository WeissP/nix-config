{
  trivialBuild,
  fetchFromGitHub,
  deps,
}:
trivialBuild rec {
  pname = "consult";
  version = "1.9";
  propagatedUserEnvPkgs = with deps; [
    compat
  ];
  buildInputs = propagatedUserEnvPkgs;
  src = (
    fetchFromGitHub {
      owner = "minad";
      repo = "consult";
      rev = version;
      hash = "sha256-JlG9SBYWU1CcIXrb8q93NMb28Ychb+xS/Z3yZ5Lc5T4=";
    }
  );
}
