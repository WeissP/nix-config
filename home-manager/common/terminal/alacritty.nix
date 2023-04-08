{ config, pkgs, ... }:

with pkgs.lib.attrsets;
{
  programs.alacritty = {
    let
      fontFamily = "FiraCode Nerd Font Mono";
      styles = {
        normal= "Regular";
        bold = "Bold";
        italic = "Italic";
        bold_italic = "Bold Italic";
      };
    in
      {
        enable = true;
        settings = {
          font = mapAttrs'
            (name : style : nameValuePair name { family = fontFamily; style = style; })
            styles
          ;
          key_bindings = [
            {
              key = "V";
              mods = "Control";
              action = "Paste";
            }
            # let alacritty pass C-Tab and C-S-Tab. Note that \ in chars is escaped
            {
              key = "Tab";
              mods = "Control";
              chars = "\\x1b[27;5;9~";
            }

            {
              key = "Tab";
              mods = "Control|Shift";
              chars = "\\x1b[27;6;9~";
            }
          ];
        };      
      };
  };
}
