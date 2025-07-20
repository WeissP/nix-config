{
  trivialBuild,
  remoteFiles,
  deps,
}:
trivialBuild rec {
  pname = "gptel-prompts";
  version = "latest";
  propagatedUserEnvPkgs = with deps; [
    gptel
  ];
  buildInputs = propagatedUserEnvPkgs;
  src = remoteFiles.gptel-prompts;
}
