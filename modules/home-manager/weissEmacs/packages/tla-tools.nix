{ trivialBuild, fetchFromGitHub }:
trivialBuild rec {
  pname = "tla-tools";
  version = "0.1";
  src = (fetchFromGitHub {
    owner = "mrc";
    repo = "tla-tools";
    rev = "0.1";
    hash = "sha256-lvadUtbPQQqWTg8i/Md3JRiFBgHWeq0tNXvPFRXZ/bE=";
  });
}
