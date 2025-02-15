{
  trivialBuild,
  remoteFiles,
  deps,
}:
trivialBuild rec {
  pname = "embark";
  version = "latest";
  propagatedUserEnvPkgs = with deps; [
    org
    avy
    compat
    consult
  ];
  buildInputs = propagatedUserEnvPkgs;
  src = remoteFiles.embark;
}
