{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.my-ytdl-sub;
  settingsFormat = pkgs.formats.yaml { };
in
{
  options.services.my-ytdl-sub = {
    package = lib.mkPackageOption pkgs "ytdl-sub" { };
    enable = lib.mkEnableOption "my-ytdl-sub";
    instances = lib.mkOption {
      default = { };
      description = "Configuration for ytdl-sub instances.";
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = with lib; {
              serviceName =
                with lib.types;
                mkOption {
                  type = str;
                  default = "ytdl-sub-${name}";
                };
              OnBootSec = with lib.types; mkOption { type = str; };
              OnUnitActiveSec = with lib.types; mkOption { type = str; };

              config = lib.mkOption {
                type = settingsFormat.type;
                description = "Configuration for ytdl-sub. See <https://ytdl-sub.readthedocs.io/en/latest/config_reference/config_yaml.html> for more information.";
                default = { };
                example = {
                  presets."YouTube Playlist" = {
                    download = "{subscription_value}";
                    output_options = {
                      output_directory = "YouTube";
                      file_name = "{channel}/{playlist_title}/{playlist_index_padded}_{title}.{ext}";
                      maintain_download_archive = true;
                    };
                  };
                };
              };

              subscriptions = lib.mkOption {
                type = settingsFormat.type;
                description = "Subscriptions for ytdl-sub. See <https://ytdl-sub.readthedocs.io/en/latest/config_reference/subscription_yaml.html> for more information.";
                default = { };
                example = {
                  "YouTube Playlist" = {
                    "Some Playlist" = "https://www.youtube.com/playlist?list=...";
                  };
                };
              };
            };
          }
        )
      );
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services =
      let
        mkService =
          name: instance:
          let
            configFile = settingsFormat.generate "config.yaml" instance.config;
            subscriptionsFile = settingsFormat.generate "subscriptions.yaml" instance.subscriptions;
          in
          lib.nameValuePair instance.serviceName {
            Unit = {
              Description = "ytdl-sub instance on ${name}";
            };

            Service = {
              ExecStart = "${lib.getExe cfg.package} --config ${configFile} sub ${subscriptionsFile}";
            };
          };
      in
      lib.mapAttrs' mkService cfg.instances;
    systemd.user.timers =
      let
        mkTimer =
          name: instance:
          lib.nameValuePair instance.serviceName {
            Unit = {
              Description = "trigger ytdl-sub instance on ${name}";
            };

            Timer = {
              inherit (instance) OnBootSec OnUnitActiveSec;
              Unit = instance.serviceName;
            };
            Install = {
              WantedBy = [ "timers.target" ];
            };
          };
      in
      lib.mapAttrs' mkTimer cfg.instances;
  };
}
