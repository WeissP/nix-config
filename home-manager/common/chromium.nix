{ pkgs, myEnv, lib, ... }:

let
  better-onetab = {
    id = "eookhngofldnbnidjlbkeecljkfpmfpg";
    sha256 = "sha256:0h7i1h6vpdgcsw139kj183y3g4wlr9ndb4yzb7j9bp5645q2cqk0";
    version = "1.4.7";
  };
  CaretTab = {
    id = "cojpndognjdcakkimaloeealehpkljna";
    sha256 = "sha256:06dawcpcgwi068sjn3mmqsvi12l4s5kb3qiki5dymng47yfy0l16";
    version = "3.8.1";
  };
  DisableAutomaticGainControl = {
    id = "clpapnmmlmecieknddelobgikompchkk";
    sha256 = "sha256:0q19mygm5wsy35i66k0qj3z01xlih399z3x4bcym5d7j34wg2fsz";
    version = "1.2";
  };
  DownloadPlus = {
    id = "gokgophibdidjjpildcdbfpmcahilaaf";
    sha256 = "sha256:056qrvmd14y5yn69m2p6i3xj04ckw8d9pggkk5qhl8rd0r0skv92";
    version = "1.6.9";
  };
  EnhancedImageViewer = {
    id = "gefiaaeadjbmhjndnhedfccdjjlgjhho";
    sha256 = "sha256:0rmxxvcafssqzlqagkpw4ckgfxsgda1wr401sqpb351wyvdv1q20";
    version = "3.1";
  };
  Imagus = {
    id = "immpkjjlgappgfkkfieppnmlhakdmaab";
    sha256 = "sha256:19mirfy8ggq2zaxp8clv28aq1lmv5xdlvf9j62ig9p75pr4v3qa1";
    version = "0.9.8.74";
  };
  ImTranslator = {
    id = "noaijdpnepcgjemiklgfkcfbkokogabh";
    sha256 = "sha256:0d5xm2baq0hpizclfwx1jxbwxf2nh71rn2kicwzqykl6mxqda2pb";
    version = "16.21";
  };
  Keepa = {
    id = "neebplgakaahbhdphmkckjjcegoiijjo";
    sha256 = "sha256:04gjjkqwy4dzz5jxs546kgjrj667c00vv702hzv56v6r0wimxq78";
    version = "3.99";
  };
  Linkclump = {
    id = "lfpjkncokllnfokkgpkobnkbkmelfefj";
    sha256 = "sha256:1fazpq2r681qyqkz3g3mix01y2lkh02jyy1vi4vzqvlh6jr7baws";
    version = "2.9.1";
  };
  ProxySwitchyOmega = {
    id = "padekgcemlokbadohgkifijomclgjgif";
    sha256 = "sha256:0b3mk9lkppa6jinv9fjhpdq7ca2c172cpkc8bs8mk19cb6155fwg";
    version = "2.5.21";
  };
  SearchTheCurrentSite = {
    id = "jliolpcnkmolaaecncdfeofombdekjcp";
    sha256 = "sha256:1z7bisdfk41h8s0lkzclbnmf8jmd3k2fzs26y86lnvgr13csybhs";
    version = "9.4";
  };
  SmartUpGestures = {
    id = "bgjfekefhjemchdeigphccilhncnjldn";
    sha256 = "sha256:0jd1s9v20gj6vqy7aphf7gpcxcw8waq6xsywdqga2dg4pm0jl6n0";
    version = "7.1.1355.1162";
  };
  uBlockOrigin = {
    id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
    sha256 = "sha256:0fcrpxv3y5n72znwgvbaa223hyb464vs2s2bjynyk26sqq09pg4j";
    version = "1.47.2";
  };
  VideoDownloadHelper = {
    id = "lmjnegcaeklhafolokijcfjliaokphfk";
    sha256 = "sha256:1rnhwjym6pm48pwklvx6pi0azxl7xdc769pfiviw3bw6cvc66iwp";
    version = "7.6.0.0";
  };
  Vimium = {
    id = "dbepggeogbaibhgnhhndojpepiihcmeb";
    sha256 = "sha256:00qhbs41gx71q026xaflgwzzridfw1sx3i9yah45cyawv8q7ziic";
    version = "1.67";
  };
  Wikiwand = {
    id = "emffkefkbkpkgpdeeooapgaicgmcbolj";
    sha256 = "sha256:0pd2m0324zhgg6bcfg068b7955vdr9nwnj3syr3shrc9xz5rxprs";
    version = "8.3.2";
  };
in (myEnv.ifLinux {
  programs.chromium = rec {
    enable = true;
    package = pkgs.ungoogled-chromium;
    extensions = let
      browserVersion = lib.versions.major package.version;
      createChromiumExtension = ext:
        with ext; {
          inherit id;
          crxPath = builtins.fetchurl {
            url =
              "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
            name = "${id}.crx";
            inherit sha256;
          };
          inherit version;
        };
    in map createChromiumExtension [
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
      VideoDownloadHelper
      Vimium
      Wikiwand
    ];
  };
})
