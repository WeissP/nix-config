{
  trivialBuild,
  remoteFiles,
  deps,
}:
trivialBuild rec {
  pname = "consult-omni";
  version = "latest";
  propagatedUserEnvPkgs = with deps; [
    consult
    embark
    compat
  ];
  buildInputs = propagatedUserEnvPkgs;
  src = remoteFiles.consult-omni;
}
