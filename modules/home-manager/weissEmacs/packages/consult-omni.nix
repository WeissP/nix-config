{
  trivialBuild,
  fetchFromGitHub,
  deps,
}:
trivialBuild rec {
  pname = "consult-omni";
  version = "87b5bcf0e55c01e6a4a24ae74ce691f55d1455a2";
  propagatedUserEnvPkgs = with deps; [
    consult
    embark
  ];
  buildInputs = propagatedUserEnvPkgs;
  src = (
    fetchFromGitHub {
      owner = "armindarvish";
      repo = "consult-omni";
      rev = version;
      hash = "sha256-x5rNTNEDLoHzIlA1y+VsQ+Y0Pa1QXbybt2rIUBJ+VtM=";
    }
  );
}
