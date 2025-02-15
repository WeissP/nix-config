{
  trivialBuild,
  remoteFiles,
  deps,
}:
trivialBuild rec {
  pname = "aider";
  version = "latest";
  propagatedUserEnvPkgs = with deps; [
    transient
    helm
    magit
  ];
  buildInputs = propagatedUserEnvPkgs;
  src = builtins.filterSource (
    path: type: baseNameOf path != "test_aider.el" && baseNameOf path != "aider-doom.el"
  ) remoteFiles.aider-el;
}
