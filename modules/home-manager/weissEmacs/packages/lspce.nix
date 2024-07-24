{ lib, emacs, f, fetchFromGitHub, markdown-mode, rustPlatform, trivialBuild
, yasnippet }:

let
  version = "fd320476df89cfd5d10f1b70303c891d3b1e3c81";

  src = fetchFromGitHub {
    owner = "zbelial";
    repo = "lspce";
    rev = version;
    hash = "sha256-KnERYq/CvJhJIdQkpH/m82t9KFMapPl+CyZkYyujslU=";
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

    cargoHash = "sha256-ndiamBlF7QnTGYkpZ3hWh57wAa7TYpkZ8Rf3o8N4CFM=";

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
