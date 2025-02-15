{
  trivialBuild,
  remoteFiles,
  deps,
}:
trivialBuild rec {
  pname = "embark-consult";
  version = "latest";
  propagatedUserEnvPkgs = with deps; [
    embark
    compat
    consult
  ];
  buildInputs = propagatedUserEnvPkgs;
  src = builtins.filterSource (path: type: baseNameOf path == "embark-consult.el") remoteFiles.embark;
}
