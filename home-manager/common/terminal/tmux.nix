{ config, pkgs, ... }:

with pkgs.lib.attrsets;
{
  programs = {
    tmux = {
      enable = false;
      baseIndex = 1;
      newSession = true;
      # Stop tmux+escape craziness.
      escapeTime = 0;
      plugins = with pkgs; [
        tmuxPlugins.better-mouse-mode
      ];

      extraConfig = ''
        set -s set-clipboard on
        set -g mouse on
        set -g mode-keys vi
        set -g status-keys vi
        set-option -gw xterm-keys on

        set -g prefix End
        unbind C-b
        bind End send-prefix

        bind Tab copy-mode
        bind v paste-buffer -p
        bind c new-window -c "#{pane_current_path}"

        bind-key -n C-n next-window
        bind-key -n C-p previous-window

        bind-key -n C-Tab next-window
        bind-key -n C-S-Tab previous-window

        set -g window-status-current-style 'underscore'
        set-option -g set-titles on
        set -g status-right ""
      '';
    };    
  };
}
