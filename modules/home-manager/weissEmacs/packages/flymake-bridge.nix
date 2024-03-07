{ trivialBuild, fetchFromGitHub, lsp-bridge, flymake }:
let rev = "30f7ee8c5234b32c6d5acac850bb97c13ee90128";
in trivialBuild rec {
  pname = "flymake-bridge";
  version = rev;
  propagatedUserEnvPkgs = [ lsp-bridge flymake ];
  buildInputs = propagatedUserEnvPkgs;
  src = (fetchFromGitHub {
    inherit rev;
    owner = "liuyinz";
    repo = "flymake-bridge";
    hash = "sha256-qpGBt0LUEQuI0wbTP69uUC7exa9LqwGh7uc1gNqDFfw=";
  });
}
