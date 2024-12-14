{
  trivialBuild,
  fetchFromGitHub,
  deps,
}:
trivialBuild rec {
  pname = "parsebib";
  version = "05fff935749e6ca29ec81fdf0163e95ad2aa6bc3";
  propagatedUserEnvPkgs = with deps; [
    # consult
    # embark
  ];
  buildInputs = propagatedUserEnvPkgs;
  src = (
    fetchFromGitHub {
      owner = "joostkremers";
      repo = "parsebib";
      rev = version;
      hash = "sha256-sKD8Ize1FEt3aZn1f+ETP/xU3I94fz/G5gvoNvHpKI8=";
    }
  );
}
