{
  myEnv,
  ...
}:
with myEnv;
let
  posixAliases = {
    redshiftDual = "redshift -m randr:crtc=0 -l 51.5:10.5 -t 6500:3300 -b 1:0.9 & redshift -m randr:crtc=1 -l 51.5:10.5 -t 6500:3300  -b 1:1 &";
    pre_beg = "dunstctl set-paused true && xscreensaver-command -exit &";
    pre_end = "dunstctl set-paused false && xscreensaver -no-splash &";
  };
  generalAliases = {
    deploy = "nix run github:serokell/deploy-rs -- -s";
    switch =
      if (arch == "linux") then
        # "sudo nixos-rebuild switch --flake ${homeDir}/nix-config#${configSession}"
        "nh os switch ${homeDir}/nix-config#nixosConfigurations.${configSession}"
      else
        "sudo darwin-rebuild switch --flake ${homeDir}/nix-config#${configSession}";
    suspend = "sudo systemctl suspend";
    ns = "nix-shell";
    ec = ''emacsclient --create-frame --alternate-editor="emacs"'';
    cg = "cargo";
    emdbg = "emacs --debug-init";
    pyav = "getAvInfo.py";
    vpnon = "nmcli connection up wgtuk-Full-Desk";
    vpnoff = "nmcli connection down wgtuk-Full-Desk";
    dc = "docker container ";
    ka = "killall -9 ";
    hibernate = "systemctl hibernate";
    hybrid-sleep = "systemctl hybrid-sleep";
    edit = "emacsclient -c";
    mnt = "bb ${homeDir}/scripts/mount.clj";
    sf = "sqlfluff fix --config ${homeDir}/.config/sqlfluff/.sqlfluff ";
    sl = "sqlfluff lint --config ${homeDir}/.config/sqlfluff/.sqlfluff ";
    sfp = "sf --dialect postgres ";
    trash = "gtrash put --home-fallback ";
    # ws = "wezterm --config-file ${configDir}/wezterm/wezterm.lua ssh weiss@192.168.0.33 -- nu -l";
  };
in
{
  programs.bash = {
    shellAliases = posixAliases // generalAliases;
  };
  programs.zsh = {
    shellAliases = posixAliases // generalAliases;
  };
  programs.nushell = {
    shellAliases = generalAliases;
  };
}
