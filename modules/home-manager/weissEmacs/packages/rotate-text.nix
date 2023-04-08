{ trivialBuild, fetchFromGitHub }:
trivialBuild rec {
  pname = "rotate-text";
  version = "0.1";
  src = (fetchFromGitHub {
    owner = "nschum";
    repo = "rotate-text.el";
    rev = "0.1";
    hash = "sha256-lvabUtbPQQqWTg8i/Md3JRiFBgHWeq0tNXvPFRXZ/bE=";
  });
}
