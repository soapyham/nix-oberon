{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.oberon;
in {
  options = {
    services.oberon.enable = mkOption {
      type = types.bool;
      default = false;
      description =
        "Enable Oberon service and related configurations (e.g., AMD GPU and OpenCL).";
    };

    services.oberon.extraGraphicsPackages = mkOption {
      type = types.listOf types.package;
      default = [ pkgs.mesa.opencl ];
      description = "Additional graphics-related packages.";
    };
  };

  config = mkIf cfg.enable {
    environment.variables = { RUSTICL_ENABLE = "radeonsi"; };

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
      extraPackages = cfg.extraGraphicsPackages;
    };

    boot.initrd.kernelModules = [ "amdgpu" ];
  };
}
