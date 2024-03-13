{ lib, python3, melpaBuild, fetchFromGitHub, substituteAll, acm, markdown-mode
, git, go, gopls, pyright, ruff, tempel, writeText, unstableGitUpdater }:

let
  rev = "d9c976c4cb7ac5af1f79ff570b7c9a689aa2bc39";
  python = python3.withPackages
    (ps: with ps; [ epc orjson paramiko rapidfuzz sexpdata six ]);
in melpaBuild {
  pname = "lsp-bridge";
  version = "20240313.1600";

  src = fetchFromGitHub {
    owner = "manateelazycat";
    repo = "lsp-bridge";
    inherit rev;
    hash = "sha256-0ZB6Wy7eFF04FCLivK6fYoiywOYa/3jNkS0WoqEbCIA=";
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
