{
  trivialBuild,
  fetchFromGitHub,
  deps,
}:
trivialBuild rec {
  pname = "embark";
  version = "d2daad08e04090391b3221fa95000492a1f8aabe";
  propagatedUserEnvPkgs = with deps; [
    org
    avy
    compat
    consult
  ];
  buildInputs = propagatedUserEnvPkgs;
  src = (
    fetchFromGitHub {
      owner = "oantolin";
      repo = "embark";
      rev = version;
      hash = "sha256-dpc08wxgZzosRJs6Cc2f7fCf1x83DZC9vL0sQ20054I=";
    }
  );
}
