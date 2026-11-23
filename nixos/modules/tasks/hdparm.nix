{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.tasks.hdparmSpindown;
in
{
  # Interface
  # ---------
  options = {
    tasks.hdparmSpindown = {
      enable = lib.mkEnableOption "hdparm spindown (APM) configuration for specified devices";

      devices = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "/dev/sda"
          "/dev/sdb"
        ];
        description = ''
          List of block devices (e.g., {file}`/dev/sda`) on which to apply
          the hdparm spindown timeout.
        '';
      };

      spindownTimeout = lib.mkOption {
        type = lib.types.int;
        default = 5;
        description = ''
          The standby (spindown) timeout value passed to `hdparm -S`.
          A value of 5 corresponds to 25 seconds (5 * 5 seconds).
          See `man hdparm` for the exact encoding.
        '';
      };
    };
  };

  # Implementation
  # --------------
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.hdparm ];

    systemd.services.hdparm-spindown = {
      description = "Configure hdparm spindown timeout on specified devices";
      wantedBy = [ "multi-user.target" ];
      after = [ "dev-disk-by\\x2ddevice\\x2d.slice" ]; # Wait for device units if possible

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        # Run as root to ensure hdparm has the necessary permissions
        User = "root";
      };

      script = ''
        # Fail if the device list is empty (optional, but likely desired)
        if [ -z "${lib.concatStringsSep " " cfg.devices}" ]; then
          echo "No devices specified for hdparm spindown."
          exit 0
        fi

        ${lib.concatMapStringsSep "\n" (dev: ''
          echo "Setting spindown timeout to ${toString cfg.spindownTimeout} on ${dev}"
          ${pkgs.hdparm}/sbin/hdparm -S${toString cfg.spindownTimeout} ${dev}
        '') cfg.devices}
      '';
    };
  };
}
