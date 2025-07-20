{
  trivialBuild,
  remoteFiles,
  deps,
  lib,
}:
trivialBuild rec {
  pname = "flyover";
  version = "latest";
  propagatedUserEnvPkgs = with deps; [
    flycheck
    flymake
  ];
  buildInputs = propagatedUserEnvPkgs;
  src = builtins.filterSource (
    path: type: !(lib.hasInfix "test" (baseNameOf path))
  ) remoteFiles.flyover;
}
