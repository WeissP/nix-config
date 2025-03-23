{
  config,
  myEnv,
  myLib,
  lib,
  pkgs,
  ...
}:
let
  gluqloRepo = pkgs.fetchFromGitHub {
    owner = "alexanderk23";
    repo = "gluqlo";
    rev = "134a6c0079268db58835f68ed8b8ef91f68c973e";
    sha256 = "sha256-bPRmMQnStPNQsR3l3N7k12Qj+Sf+e8HjhG4ihrqXr0I=";
  };
in
{
  # Create a systemd service that runs at startup to ensure the Gluqlo font is available
  systemd.services.gluqlo-font-setup = {
    description = "Setup Gluqlo font";
    wantedBy = [ "multi-user.target" ];

    # Run after filesystem is mounted and network is online
    after = [
      "local-fs.target"
      "network-online.target"
    ];
    wants = [ "network-online.target" ];

    # Run as oneshot service
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "gluqlo-font-setup" ''
        FONT_DIR="/usr/share/gluqlo"
        FONT_PATH="$FONT_DIR/gluqlo.ttf"

        # Check if font directory exists, create if not
        if [ ! -d "$FONT_DIR" ]; then
          mkdir -p "$FONT_DIR"
        fi

        # Check if font already exists
        if [ ! -f "$FONT_PATH" ]; then
          echo "Installing Gluqlo font..."
          
          # Copy the font file from the fetched repository
          cp "${gluqloRepo}/gluqlo.ttf" "$FONT_PATH"
          echo "Gluqlo font installed successfully."
        else
          echo "Gluqlo font already exists at $FONT_PATH"
        fi
      ''}";
      RemainAfterExit = false;
    };
  };
}
