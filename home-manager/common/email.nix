{ pkgs, config, lib, myEnv, secrets, ... }:
with myEnv;
let
  notmuchConfigPath = "${homeDir}/.config/notmuch";
  notmuchTagPath = ./config_files/notmuch/tags;
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
        hooks = {
          postNew = "notmuch tag --batch --input=${notmuchTagPath}";
          # preNew = pkgs.fetchFromGitHub {
          #   owner = "wkz";
          #   repo = "notmuch-lore";
          #   rev = "3e2a13b32b178a4d3296cee6f69ee3491eebdb9f";
          #   sha256 = "sha256-aNb0uf7jCfP00bLMDY4aY26FRiBd2YL51O+cxSS4DAk=";
          # } + "/pre-new";
        };
      };
    };
    # home.file = {
    #   # = { source = ./config_files/notmuch; }
    #   notmuchTagPath.text = "f";
    # };
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
        passwordCommand = withPass "rptu" first;
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

