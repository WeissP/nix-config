{ trivialBuild, fetchFromGitHub, deps }:
trivialBuild rec {
  pname = "chatu-xournal";
  version = "87374a592837417b33e61858876d28ab97ba413b";
  propagatedUserEnvPkgs = with deps; [ f chatu ];
  buildInputs = propagatedUserEnvPkgs;
  src = (fetchFromGitHub {
    owner = "WeissP";
    repo = "chatu-xournal";
    rev = version;
    hash = "sha256-jrEpV2W65CnZoYuTPL1nBFvDwLpo7u5Fa50fLZtyvoA=";
  });
}

