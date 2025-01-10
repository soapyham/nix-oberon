{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.oberon-governor;
in {
  options = {
    services.oberon-governor.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the Oberon Governor service.";
    };
  };

  config = mkIf cfg.enable {
    # Define the systemd service for Oberon Governor
    systemd.services.oberon-governor = {
      enable = true;
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "5s";
        ExecStart = "${pkgs.oberon-governor}/bin/oberon-governor";
      };
    };
  };
}
