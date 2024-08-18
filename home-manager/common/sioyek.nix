{ pkgs, myEnv, myLib, lib, ... }: {
  programs.sioyek = rec {
    enable = true;
    config = {
      "should_launch_new_window" = "1";
      "link_highlight_color" = "green";
    };
    bindings = {
      "copy" = "c";
      "screen_down" = "<enter>";
      "next_page" = "j";
      "previous_page" = "k";
      "move_down" = [ "." "<down>" ];
      "move_up" = [ "," "<up>" ];
      "move_left" = "i";
      "move_right" = "l";
      "fit_to_page_width" = "w";
      "fit_to_page_height" = "h";
      "goto_begining" = "<space>h";
      "goto_end" = "<space>n";
    };
  };
}
