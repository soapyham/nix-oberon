{ config, lib, pkgs, ... }:

with lib;

let cfg = config.modules.oberon-governor;
in {
  options = {
    modules = {
      oberon-governor = {
        enable = mkOption {
          type = types.bool;
          default = false;
        };
        package = mkPackageOption pkgs "oberon-governor" { };
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services.oberon-governor = {
      enable = true;
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "5s";
        ExecStart = "${cfg.package}/bin/oberon-governor";
      };
    };
  };
}
