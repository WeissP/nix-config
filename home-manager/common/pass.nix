{ pkgs, config, myEnv, secrets, ... }:
with myEnv;
let dir = "${homeDir}/.password-store";
in {
  home.packages = with pkgs; [ zbar xclip  ];
  programs = {
    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
      settings = { PASSWORD_STORE_DIR = "${dir}"; };
    };
    zsh.shellAliases.otp =
      "xclip -selection clipboard -t image/png -o | zbarimg --raw - | pass otp";
  };
}

