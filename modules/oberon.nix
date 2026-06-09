{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.oberon;
in {
  options = {
    services.oberon.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Oberon service and related configurations (e.g., AMD GPU and OpenCL).";
    };

    services.oberon.extraGraphicsPackages = mkOption {
      type = types.listOf types.package;
      default = [pkgs.mesa.opencl];
      description = "Additional graphics-related packages.";
    };

    services.oberon.settings = mkOption {
      type = types.anything;
      default = {};
      description = "Setting to pass to the governor";
    };

    services.oberon.unlock_cu = mkOption {
      type = types.bool;
      default = false;
      description = "EXPERIMENTAL. Unlock all 40cus";
    };
  };

  config = mkIf cfg.enable {
    environment.variables = {
      RUSTICL_ENABLE = "radeonsi";
    };

    services.cyan-skillfish-governor = {
      enable = true;
      settings = cfg.settings;
    };

    services.xserver.videoDrivers = ["amdgpu"];
    boot.kernelModules = ["nct6687"];
    boot.kernelParams = [
      "amdgpu.ppfeaturemask=0xffffffff"
      "amdgpu.sg_display=0"
      "acpi=noirq"
      "usbcore.autosuspend=-1"
    ];
    #TODO: use cachyos kernel
    boot.kernelPatches = lib.optionals cfg.unlock_cu [
      {
        name = "unlock40cu";
        patch = (
          pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/duggasco/bc250-40cu-unlock/11093c6226d9dd4a25d5f66bd380299087c39a3d/patch/bc250-40cu-amdgpu.patch";
            hash = "sha256-lQrdjAwVxWlN7zOch+al0dZdeuigMAJRmiWsI721de0=";
          }
        );
      }
    ];

    hardware.graphics = {
      enable = true;
      extraPackages = cfg.extraGraphicsPackages;
    };

    boot.initrd.kernelModules = ["amdgpu"];
  };
}
