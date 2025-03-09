{
  trivialBuild,
  deps,
  remoteFiles,
}:
trivialBuild rec {
  pname = "consult";
  version = "latest";
  propagatedUserEnvPkgs = with deps; [
    compat
  ];
  buildInputs = propagatedUserEnvPkgs;
  src = remoteFiles.consult;
}
