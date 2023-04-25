{ pkgs, config, lib, myEnv, secrets, ... }:
with myEnv;
let
  tags_path = "${config.xdg.configHome}/notmuch_tags";
  withPass = name: extract: "${userBin "pass"} ${name} 2>&1 | ${extract}";
  withGrep = prefix:
    "${systemBin "grep"} '^${prefix}' | ${systemBin "cut"} -c${
      toString (lib.stringLength prefix + 1)
    }-";
  first = "${systemBin "head"} -n 1";
in lib.mkMerge [
  {
    programs = {
      mbsync.enable = true;
      msmtp.enable = true;
      notmuch = {
        enable = true;
        hooks = { postNew = "notmuch tag --batch --input=${tags_path}/tags"; };
      };
    };
    home.packages = with pkgs; [ pass ];
    home.file."${tags_path}" = {
      source = ./config_files/notmuch_tags;
      recursive = true;
    };
    accounts.email.accounts = let
      genAcc = { address, imap, primary, passwordCommand, smtp ? null }: {
        inherit address primary imap smtp passwordCommand;
        userName = address;
        msmtp.enable = smtp != null;
        notmuch.enable = true;
        mbsync = {
          enable = true;
          create = "maildir";
        };
        realName = secrets.realName;
      };
    in {
      rptu = genAcc {
        address = secrets.email.rptu;
        imap.host = "mail.uni-kl.de";
        primary = true;
        passwordCommand = withPass "tuk" first;
        smtp = {
          host = "smtp.uni-kl.de";
          port = 465;
          tls.enable = true;
        };
      };

      webde = genAcc {
        address = secrets.email.webde;
        imap.host = "imap.web.de";
        primary = false;
        passwordCommand = withPass "webde" first;
        smtp = {
          host = "smtp.web.de";
          port = 587;
          tls.enable = true;
          tls.useStartTls = true;
        };
      };

      rptu_cs = genAcc {
        address = secrets.email.rptu_cs;
        imap.host = "mail.uni-kl.de";
        primary = false;
        passwordCommand = withPass "cs-tuk" first;
        smtp = {
          host = "smtp.uni-kl.de";
          port = 587;
          tls.enable = true;
          tls.useStartTls = true;
        };
      };

      "163" = genAcc {
        address = secrets.email."163";
        imap.host = "imap.163.com";
        primary = false;
        passwordCommand = withPass "163" (withGrep "shou-quan-ma: ");
      };

      gmail = genAcc {
        address = secrets.email.gmail;
        imap.host = "imap.gmail.com";
        primary = false;
        passwordCommand = withPass "google" (withGrep "mail_imap: ");
      };
    };
  }
  (ifLinux {
    services.mbsync = {
      enable = true;
      frequency = "*:0/3"; # every 3 minutes
    };
  })
]

