{ trivialBuild, fetchFromGitHub, polymode }:
trivialBuild rec {
  pname = "tla-tools";
  version = "0.1";
  propagatedUserEnvPkgs = [ polymode ];
  buildInputs = propagatedUserEnvPkgs;
  src = (fetchFromGitHub {
    owner = "mrc";
    repo = "tla-tools";
    rev = "61a14b40713c8c528b2149ea5b255c6ec789c118";
    hash = "sha256-nM75YamjZA+VkPEhTepuTwowNBKklKbjoyVsE7jhYf0=";
  });
}
