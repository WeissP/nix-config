{ pkgs, config, myEnv, secrets, ... }:
with myEnv;
let
  tags_path = "${config.xdg.configHome}/notmuch_tags";
  with_pass = name: extract: "${userBin "pass"} ${name} 2>&1 | ${extract}";
in {
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
      passwordCommand = with_pass "tuk" "head -n 1";
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
      passwordCommand = with_pass "webde" "head -n 1";
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
      passwordCommand = with_pass "cs-tuk" "head -n 1";
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
      passwordCommand = with_pass "163" "grep '^shou-quan-ma:' | cut -c15-";
    };

    gmail = genAcc {
      address = secrets.email.gmail;
      imap.host = "imap.gmail.com";
      primary = false;
      passwordCommand = with_pass "google" "grep '^mail_imap: ' | cut -c12-";
    };
  };
}

