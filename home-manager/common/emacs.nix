{ pkgs, config, inputs, system, ... }:

{
  home.packages = with pkgs; [
    haskellPackages.Agda
    weissNur.telega-server
    weissNur.emacs-rime
    # myPkgs.recentf
  ];
  programs.emacs.enable = true;
  home.file.".emacs.d" = {
    source = ./config_files/emacs;
    recursive = true;
  };
  home.file.".emacs.d/nix-extra.el".text = ''
    (setq emacs-host (nth 0 emacs-host-list))
    (setq rime--module-path "${pkgs.weissNur.emacs-rime.outPath}/include/librime-emacs.so")
  '';
  home.file.".emacs.d/weiss-emacs-host.el".text =
    "(setq emacs-host (nth 0 emacs-host-list))";
}

