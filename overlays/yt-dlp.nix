# based on https://github.com/mitchty/nix/blob/shenanigans/nix/overlays/yt-dlp.nix

final: prev:
let
  getDeps = x: map (p: "${p}/${p.pythonModule.sitePackages}") ([ x ] ++ x.propagatedBuildInputs);
  toPathWithSep = x: prev.pkgs.lib.concatStringsSep ":" (getDeps x);
in
rec {
  bgutil-ytdlp-pot-provider = prev.python3Packages.buildPythonPackage rec {
    pname = "bgutil-ytdlp-pot-provider";
    version = "1.1.0";
    pyproject = true;
    src = prev.fetchFromGitHub {
      owner = "Brainicism";
      repo = "bgutil-ytdlp-pot-provider";
      rev = version;
      hash = "sha256-gcDeLW0MF6Y4Qzaa2nn12lIeK6DB9gSBkBjqsnmdj/M=";
    };
    # propagatedBuildInputs = [ yt-dlp-get-pot ];
    postUnpack = "pwd; ls; cp source/README.md source/plugin/";
    sourceRoot = "source/plugin";
    build-system = [ prev.python3Packages.hatchling ];
    doCheck = false;
    pythonImportsCheck = [ "yt_dlp_plugins" ];
    latest = "curl --silent https://api.github.com/repos/Brainicism/bgutil-ytdlp-pot-provider/tags | jq -r '.[] | .name' | grep -Ev post | head -n 1";
  };
  yt-dlp = prev.yt-dlp.overrideAttrs (old: rec {
    latest = "curl --silent https://api.github.com/repos/yt-dlp/yt-dlp/tags | jq -r '.[] | .name' | grep -Ev post | head -n 1 | sed -E 's/\\.0?([1-9])/\\.\\1/g'";
    version = "2025.6.30";
    src = prev.fetchPypi {
      inherit version;
      pname = "yt_dlp";
      hash = "sha256-bQroVcClW/zCjf+6gE7IUlublV00pBGRoVYaTOwD2L0=";
    };
    # postPatch = ''
    #   true
    # '';
    propogatedBuildInputs = (prev.yt-dlp.propogatedBuildInputs or [ ]) ++ [
      # final.yt-dlp-get-pot
      final.bgutil-ytdlp-pot-provider
    ];
  });

  # yt-dlp but wrapped with the po token plugin(s)
  yt-dlp-with-plugins =
    let
      # extract appropriate python3Packages name and use this for the PYTHONPATH
      pp = with builtins; head (filter (x: x.pname == "python3") final.yt-dlp.propagatedBuildInputs);
    in
    prev.symlinkJoin {
      name = "yt-dlp-with-plugins";
      paths = [ final.yt-dlp ];
      buildInputs = [ prev.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/yt-dlp \
          --prefix PYTHONPATH : "${
            toPathWithSep final.${pp.pythonAttr}.pkgs.yt-dlp
          }:${toPathWithSep final.bgutil-ytdlp-pot-provider}"
      '';
    };

  # wrap ytdl-sub similarly
  ytdl-sub-with-plugins =
    let
      # extract appropriate python3Packages name and use this for the PYTHONPATH
      pp = with builtins; head (filter (x: x.pname == "python3") final.yt-dlp.propagatedBuildInputs);
    in
    prev.symlinkJoin {
      name = "ytdl-sub-with-plugins";
      paths = [ final.ytdl-sub ];
      buildInputs = [ prev.makeWrapper ];
      meta.mainProgram = "ytdl-sub";
      postBuild = ''
        wrapProgram $out/bin/ytdl-sub \
          --prefix PYTHONPATH : "${
            toPathWithSep final.${pp.pythonAttr}.pkgs.yt-dlp
          }:${toPathWithSep final.bgutil-ytdlp-pot-provider}"
      '';
    };
}
