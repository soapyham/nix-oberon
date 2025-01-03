{ config, lib, pkgs, ... }:

with lib;

let cfg = config.oberon;
in {
  options = {
    oberon = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {

    options.oberon-governor.enable = true;

    environment.variables = {
      #RADV_DEBUG = "nocompute";
      RUSTICL_ENABLE = "radeonsi";
    };

    services.xserver.videoDrivers = [ "amdgpu" ];

    boot.kernelModules = [ "nct6687" ];
    boot.kernelParams = [
      "amdgpu.ppfeaturemask=0xffffffff"
      "amdgpu.sg_display=0"
      "acpi=noirq"
      "usbcore.autosuspend=-1"
    ];

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [ mesa.opencl ];
    };

    boot.initrd.kernelModules = [ "amdgpu" ];
  };
}
