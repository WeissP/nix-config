{ pkgs, config, myEnv, secrets, ... }:
with myEnv;
let dir = "${homeDir}/.password-store";
in {
  programs.password-store = {
    enable = true;
    settings = { PASSWORD_STORE_DIR = "${dir}"; };
  };
}

