{
  trivialBuild,
  fetchFromGitHub,
  deps,
}:
trivialBuild rec {
  pname = "aider";
  version = "20a72c239b05a97d9f17e69891dd022481b257e9";
  propagatedUserEnvPkgs = with deps; [ transient helm];
  buildInputs = propagatedUserEnvPkgs;
  src = (
    fetchFromGitHub {
      owner = "tninja";
      repo = "aider.el";
      rev = version;
      hash = "sha256-E7L+OczHNA8FsbWmJGzjRf5+vkBWqwuMF21TDfx7tNo=";
    }
  );
}
