{ pkgs, myEnv, configSession, ... }:
with myEnv;
let
  emacs = "Exec=GTK_IM_MODULE= QT_IM_MODULE= XMODIFIERS= emacs";
  shellAliases = {
    inherit emacs;
    switch = if (arch == "linux") then
      "sudo nixos-rebuild switch --flake ${homeDir}/nix-config#${configSession}"
    else
      "darwin-rebuild switch --flake ${homeDir}/nix-config#${configSession}";
    suspend = "sudo systemctl suspend";
    ns = "nix-shell";
    ec = ''emacsclient --create-frame --alternate-editor="${emacs}"'';
    emdbg = "${emacs} --debug-init &";
    pyav = "$SCRIPTS_DIR/getAvInfo.py";
    vpnon = "nmcli connection up wgtuk-Full-Desk";
    vpnoff = "nmcli connection down wgtuk-Full-Desk";
    dc = "docker container ";
    qmkc =
      "cd /home/weiss/qmk_firmware/keyboards && qmk compile -kb handwired/dactyl_manuform/6x6 -km weiss";
    qmkf =
      "cd /home/weiss/qmk_firmware/keyboards && qmk flash -kb handwired/dactyl_manuform/6x6 -km weiss";
    ka = "killall -9 ";
    hibernate = "systemctl hibernate";
    hybrid-sleep = "systemctl hybrid-sleep";
    edit = "emacsclient -c";
    redshiftDual =
      "redshift -m randr:crtc=0 -l 51.5:10.5 -t 6500:3300 -b 1:0.9 & redshift -m randr:crtc=1 -l 51.5:10.5 -t 6500:3300  -b 1:1 &";
    mnt = "bb ${homeDir}/scripts/mount.clj";
    pre_beg = "dunstctl set-paused true && xscreensaver-command -exit &";
    pre_end = "dunstctl set-paused false && xscreensaver -no-splash &";
  };
in {
  programs.bash = { inherit shellAliases; };
  programs.zsh = { inherit shellAliases; };
}

