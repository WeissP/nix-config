{
  trivialBuild,
  remoteFiles,
  deps,
}:
trivialBuild rec {
  pname = "citar-embark";
  version = "latest";
  propagatedUserEnvPkgs = with deps; [
    embark
    citar
  ];
  buildInputs = propagatedUserEnvPkgs;
  src = builtins.filterSource (path: type: baseNameOf path == "citar-embark.el") remoteFiles.citar;
}
