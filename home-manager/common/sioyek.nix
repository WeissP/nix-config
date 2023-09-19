{ pkgs, myEnv, myLib, lib, ... }: {
  programs.sioyek = rec {
    enable = true;
    bindings = {
      "next_page" = "j";
      "previous_page" = "k";
      "move_down" = [ "." "<down>" ];
      "move_up" = [ "," "<up>" ];
      "move_left" = "h";
      "move_right" = "l";
      "fit_to_page_width_smart" = "w";
      "fit_to_page_height_smart" = "h";
    };
  };
}
