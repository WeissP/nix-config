{ lib, python3, melpaBuild, fetchFromGitHub, substituteAll, acm, markdown-mode
, git, go, gopls, pyright, ruff, tempel, writeText, unstableGitUpdater }:

let
  rev = "7c703394448d9610a1048100e4fbbc926c977885";
  python = python3.withPackages
    (ps: with ps; [ epc orjson paramiko rapidfuzz sexpdata six ]);
in melpaBuild {
  pname = "lsp-bridge";
  version = "20240307.1208";

  src = fetchFromGitHub {
    owner = "manateelazycat";
    repo = "lsp-bridge";
    inherit rev;
    hash = "sha256-7YQvhofHtinqGkFRUHanHEapmavvZ63gGecZQqbAuSA=";
  };

  commit = rev;

  patches = [
    # Hardcode the python dependencies needed for lsp-bridge, so users
    # don't have to modify their global environment
    (substituteAll {
      src = ./hardcode-dependencies.patch;
      python = python.interpreter;
    })
  ];

  packageRequires = [ acm markdown-mode ];

  checkInputs = [ git go gopls pyright python ruff tempel ];

  recipe = writeText "recipe" ''
    (lsp-bridge
      :repo "manateelazycat/lsp-bridge"
      :fetcher github
      :files
      ("*.el"
       "lsp_bridge.py"
       "core"
       "langserver"
       "multiserver"
       "resources"))
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    cd "$sourceRoot"
    mkfifo test.log
    cat < test.log &
    HOME=$(mktemp -d) python -m test.test

    runHook postCheck
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A blazingly fast LSP client for Emacs";
    homepage = "https://github.com/manateelazycat/lsp-bridge";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fxttr kira-bruneau ];
  };
}
