{ pkgs, myEnv, configSession, ... }:
with myEnv;
let
  shellAliases = {
    switch = if (arch == "linux") then
      "sudo nixos-rebuild switch --flake ${homeDir}/nix-config#${configSession}"
    else
      "darwin-rebuild switch --flake ${homeDir}/nix-config#${configSession}";
    py = "python";
    ec = ''emacsclient --create-frame --alternate-editor=""'';
    ed = "emacs --dump-file='/home/weiss/.emacs.d/emacs.pdmp' &";
    emdbg = "emacs --debug-init &";
    edmake = "emacs --batch -q -l ~/.emacs.d/dump.el";
    pyav = "python /home/weiss/Python/getAvInfo.py";
    vpnon = "nmcli connection up wgtuk-Full-desk";
    vpnoff = "nmcli connection down wgtuk-Full-desk";
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
    mnt = "bb /home/weiss/scripts/mount.clj";
    mp = "mplayer ";
    pre_beg = "dunstctl set-paused true && xscreensaver-command -exit &";
    pre_end = "dunstctl set-paused false && xscreensaver -no-splash &";
    cg = "cargo";
  };
in {
  programs.bash = { inherit shellAliases; };
  programs.zsh = { inherit shellAliases; };
}

