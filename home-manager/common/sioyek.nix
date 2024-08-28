{ pkgs, myEnv, myLib, lib, ... }: {
  programs.sioyek = rec {
    enable = true;
    config = {
      "should_launch_new_window" = "1";
      "link_highlight_color" = "green";
    };
    bindings = {
      "copy" = "c";
      "screen_down" = "j";
      "screen_up" = "k";
      "move_down" = [ "." "<down>" ];
      "move_up" = [ "," "<up>" ];
      "prev_state" = "i";
      "next_state" = "l";
      "fit_to_page_width" = "w";
      "fit_to_page_height" = "h";
      "goto_begining" = "gh";
      "goto_end" = "gn";
      "keyboard_overview" = "<C-h>";
      "toggle_highlight" = "gl";
      "open_prev_doc" = "o";
      "open_document" = "O";
    };
  };
}
