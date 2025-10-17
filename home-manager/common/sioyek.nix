{
  pkgs,
  myEnv,
  myLib,
  lib,
  ...
}:
let
  # sioyekPkg = pkgs.writers.writeBashBin "sioyek-env" {
  #   makeWrapperArgs = [
  #     "--set"
  #     "QT_QPA_PLATFORMTHEME"
  #     "flatpak"
  #   ];
  # } (lib.getExe pkgs.sioyek);
  sioyekPkg = pkgs.sioyek;
  sioyekPkgPath = lib.getExe sioyekPkg;
in
{
  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "sioyek.desktop" ];
      };
    };
    desktopEntries = {
      sioyek = {
        name = "Sioyek";
        genericName = "PDF Viewer";
        terminal = false;
        exec = "${sioyekPkgPath} %f";
        settings = {
          TryExec = sioyekPkgPath;
        };
        categories = [
          "Office"
          "Viewer"
          "Education"
        ];
        mimeType = [ "application/pdf" ];
        icon = "sioyek";
      };
    };
  };
  programs.sioyek = {
    enable = true;
    package = sioyekPkg;
    config = {
      "should_launch_new_window" = "1";
      "link_highlight_color" = "green";
    };
    bindings = {
      "move_visual_mark_down" = ",";
      "move_visual_mark_up" = ".";
      "overview_definition" = "-";
      "add_highlight_with_current_type" = "//";
      "set_select_highlight_type" = "/s";
      "goto_highlight" = "/g";
      "copy" = "c";
      "zoom_in" = "<C-+>";
      "zoom_out" = "<C-->";
      "screen_down" = "j";
      "screen_up" = "k";
      "move_down" = [ "<down>" ];
      "move_up" = [ "<up>" ];
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
