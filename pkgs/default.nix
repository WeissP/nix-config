# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{
  pkgs ? (import ../nixpkgs.nix) { },
  myLib ? { },
  secrets ? { },
}:
let
  lib = pkgs.lib;
  mkFont = pkgs.callPackage myLib.mkFont { };
in
rec {
  metatube-server = pkgs.callPackage ./metatube-server.nix { };
  mpv-bookmarker = pkgs.callPackage ./mpv-bookmarker.nix { };
  mpv-thumbfast = pkgs.callPackage ./mpv-thumbfast.nix { };
  ammonite = pkgs.callPackage ./ammonite.nix { };
  private-gpt = pkgs.callPackage ./private-gpt { };
  gluqlo = pkgs.callPackage ./gluqlo.nix { };
  aider-chat = pkgs.callPackage ./aider.nix { };
  mill = pkgs.callPackage ./mill.nix { };
  notify = pkgs.callPackage ./notify.nix {
    inherit pkgs lib secrets;
  };
  formatRon = pkgs.callPackage ./ron.nix { inherit pkgs lib; };
  monolisa = mkFont "monolisa" "monolisa.zip";
  florencesans = mkFont "florencesans-sc" "florencesans-sc.zip";
  writeNuBinWithConfig =
    name: nuCfg: script:
    let
      modules =
        if (builtins.hasAttr "modules" nuCfg) then
          (lib.concatStringsSep "\n" (map (mod: "use ${mod}") nuCfg.modules))
        else
          "";
      envs =
        if (builtins.hasAttr "env" nuCfg) then
          lib.concatMapAttrsStringSep "\n" (name: val: "$env.${name} = ${val}") nuCfg.env
        else
          "";
      config = pkgs.writeTextFile {
        name = "nushell-config";
        text = "${modules}\n${envs}";
      };
      interpreter = "${lib.getExe pkgs.nushell} --config ${config}";
    in
    pkgs.writers.makeScriptWriter { inherit interpreter; } "/bin/${name}" script;
  sing-box = pkgs.callPackage ./sing-box.nix { };
}
