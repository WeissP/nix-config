final: prev:
# Doesn't work with non-default python version

let
  newerVer = "2025.09.23";
  getDeps = x: map (p: "${p}/${p.pythonModule.sitePackages}") ([ x ] ++ x.propagatedBuildInputs);
  toPathWithSep = x: prev.pkgs.lib.concatStringsSep ":" (getDeps x);
  overrides-fresh = _: {
    name = "yt-dlp-${newerVer}";
    version = newerVer;
    src = prev.fetchFromGitHub {
      owner = "yt-dlp";
      repo = "yt-dlp";
      rev = newerVer;
      hash = "sha256-FeIoV7Ya+tGCMvUUXmPrs4MN52zwqrcpzJ6Arh4V453=";
    };
  };
  overrides-plugins = oa: {
    propagatedBuildInputs = (oa.propagatedBuildInputs or [ ]) ++ [
      bgutil-ytdlp-pot-provider
    ];
  };
  overrides-fresh-plugins = oa: (overrides-fresh oa) // (overrides-plugins oa);
  yt-dlp = prev.yt-dlp.overridePythonAttrs (
    # if prev.lib.versionAtLeast prev.yt-dlp.version newerVer then
    #   overrides-plugins
    # else
      overrides-fresh-plugins
  );
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

  bgutil-ytdlp-pot-provider = prev.python3Packages.buildPythonPackage rec {
    pname = "bgutil-ytdlp-pot-provider";
    version = "1.2.2";
    pyproject = true;
    src = prev.fetchFromGitHub {
      owner = "Brainicism";
      repo = "bgutil-ytdlp-pot-provider";
      rev = version;
      hash = "sha256-KKImGxFGjClM2wAk/L8nwauOkM/gEwRVMZhTP62ETqY=";
    };
    postUnpack = "pwd; ls; cp source/README.md source/plugin/";
    sourceRoot = "source/plugin";
    build-system = [ prev.python3Packages.hatchling ];
    doCheck = false;
    pythonImportsCheck = [ "yt_dlp_plugins" ];
  };
in
{
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (_: pyPrev: {
      yt-dlp = pyPrev.toPythonModule yt-dlp;
      # ytdl-sub-with-plugins = pyPrev.toPythonModule ytdl-sub-with-plugins;
      #yt-dlp = builtins.trace yt-dlp pyPrev.toPythonModule (yt-dlp.override {
      #  python3Packages = pyFinal;
      #});
      inherit bgutil-ytdlp-pot-provider ytdl-sub-with-plugins;
    })
  ];

  inherit yt-dlp ytdl-sub-with-plugins bgutil-ytdlp-pot-provider;
}
