{ pkgs, config, secrets, ... }:
let tags_path = "${config.xdg.configHome}/notmuch_tags";
in {
  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
    notmuch = {
      enable = true;
      hooks = { postNew = "notmuch tag --batch --input=${tags_path}/tags"; };
    };
  };
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
      primary = false;
      passwordCommand = "pass tuk 2>&1 | head -n 1";
      smtp = {
        host = "smtp.uni-kl.de";
        port = 465;
        tls.enable = true;
      };
    };

    webde = genAcc {
      address = secrets.email.webde;
      imap.host = "imap.web.de";
      primary = true;
      passwordCommand = "pass webde 2>&1 | head -n 1";
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
      passwordCommand = "pass cs-tuk 2>&1 | head -n 1";
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
      passwordCommand = "pass 163 2>&1 | grep '^授权码：' | cut -c13-";
    };

    gmail = genAcc {
      address = secrets.email.gmail;
      imap.host = "imap.gmail.com";
      primary = false;
      passwordCommand = "pass google 2>&1 | grep '^mail_imap: ' | cut -c12-";
    };
  };
}

