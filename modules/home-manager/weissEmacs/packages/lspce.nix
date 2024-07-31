{ lib, emacs, f, fetchFromGitHub, markdown-mode, rustPlatform, trivialBuild
, yasnippet }:

let
  version = "44dad3df967fb7170ac639e0de36ccb375e429e9";

  src = fetchFromGitHub {
    owner = "zbelial";
    repo = "lspce";
    rev = version;
    hash = "sha256-lrjfvKsvXR+iiqW36yRivXPKZLLi/43a7wZtUu1RRFs=";
  };

  meta = {
    homepage = "https://github.com/zbelial/lspce";
    description = "LSP Client for Emacs implemented as a module using rust";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    inherit (emacs.meta) platforms;
  };

  lspce-module = rustPlatform.buildRustPackage {
    inherit version src meta;
    pname = "lspce-module";

    cargoHash = "sha256-9fXU4zXJizdoVaweSvd4Y3ykpWhZLrAn354ZN2MqRKw=";

    checkFlags = [
      # flaky test
      "--skip=msg::tests::serialize_request_with_null_params"
    ];

    postInstall = ''
      mkdir -p $out/share/emacs/site-lisp
      for f in $out/lib/*; do
        mv $f $out/share/emacs/site-lisp/lspce-module.''${f##*.}
      done
      rmdir $out/lib
    '';
  };
in trivialBuild rec {
  inherit version src meta;
  pname = "lspce";

  buildInputs = propagatedUserEnvPkgs;

  propagatedUserEnvPkgs = [ f markdown-mode yasnippet lspce-module ];

  passthru = { inherit lspce-module; };
}
