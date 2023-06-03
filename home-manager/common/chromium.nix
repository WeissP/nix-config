{ pkgs, myEnv, myLib, lib, ... }:

let
  package = pkgs.chromium;

  better-onetab = "eookhngofldnbnidjlbkeecljkfpmfpg";
  CaretTab = "cojpndognjdcakkimaloeealehpkljna";
  DisableAutomaticGainControl = "clpapnmmlmecieknddelobgikompchkk";
  DownloadPlus = "gokgophibdidjjpildcdbfpmcahilaaf";
  EnhancedImageViewer = "gefiaaeadjbmhjndnhedfccdjjlgjhho";
  Imagus = "immpkjjlgappgfkkfieppnmlhakdmaab";
  ImTranslator = "noaijdpnepcgjemiklgfkcfbkokogabh";
  Keepa = "neebplgakaahbhdphmkckjjcegoiijjo";
  Linkclump = "lfpjkncokllnfokkgpkobnkbkmelfefj";
  ProxySwitchyOmega = "padekgcemlokbadohgkifijomclgjgif";
  SearchTheCurrentSite = "jliolpcnkmolaaecncdfeofombdekjcp";
  SmartUpGestures = "bgjfekefhjemchdeigphccilhncnjldn";
  uBlockOrigin = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
  VideoDownloadHelper = "lmjnegcaeklhafolokijcfjliaokphfk";
  Vimium = "dbepggeogbaibhgnhhndojpepiihcmeb";
  Wikiwand = "emffkefkbkpkgpdeeooapgaicgmcbolj";
  GitZip = "ffabmkklhbepgcgfonabamgnfafbdlkn";
  infyScroll = "gdnpnkfophbmbpcjdlbiajpkgdndlino";
  videoDownloadCocoCut = "gddbgllpilhpnjpkdbopahnpealaklle";
in (myEnv.ifLinux {
  programs.chromium = rec {
    inherit package;
    enable = true;
    extensions = [
      better-onetab
      CaretTab
      DisableAutomaticGainControl
      DownloadPlus
      EnhancedImageViewer
      Imagus
      ImTranslator
      Keepa
      Linkclump
      ProxySwitchyOmega
      SearchTheCurrentSite
      SmartUpGestures
      uBlockOrigin
      videoDownloadCocoCut
      Vimium
      Wikiwand
      GitZip
      infyScroll
    ];
  };
})
