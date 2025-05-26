{
  pkgs,
  secrets,
  myEnv,
  ...
}:

with myEnv;

{
  services.myStash = {
    enable = true;
    openFirewall = true;
    # jwtSecretKeyFile = "/home/weiss/Downloads/jwt";
    # sessionStoreKeyFile = "/home/weiss/Downloads/session";
    # username = username;
    settings = {
      # username = username;
      # password = "1";
      # passwordFile = "/home/weiss/nix-config/nixos/common/pw.txt";
      stash = [
        {
          path = "/home/weiss/Downloads/xx";
        }
      ];
    };
  };
}
