{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.cyan-skillfish-governor;
  defaultConfigPath = "${pkgs.cyan-skillfish-governor.src}/default-config.toml";
  defaultSettings = fromTOML (builtins.readFile defaultConfigPath);
  tomlFormat = pkgs.formats.toml {};
  configFile = tomlFormat.generate "config.toml" cfg.settings;
in {
  options.services.cyan-skillfish-governor = with lib.types; {
    enable = mkOption {
      type = bool;
      default = false;
    };
    settings = mkOption {
      type = types.submodule {
        freeformType = tomlFormat.type;
        options = {
          timing = {
            intervals = {
              sample = mkOption {
                type = types.int;
                default = defaultSettings.timing.intervals.sample;
              };
              adjust = mkOption {
                type = types.int;
                default = defaultSettings.timing.intervals.adjust;
              };
            };
            ramp-rates = {
              normal = mkOption {
                type = types.int;
                default = defaultSettings.timing.ramp-rates.normal;
              };
              burst = mkOption {
                type = types.int;
                default = defaultSettings.timing.ramp-rates.burst;
              };
            };
            burst-samples = mkOption {
              type = types.int;
              default = defaultSettings.timing.burst-samples;
            };
            down-events = mkOption {
              type = types.int;
              default = defaultSettings.timing.down-events;
            };
          };

          gpu-usage = {
            fix-metrics = mkOption {
              type = types.bool;
              default = defaultSettings.gpu-usage.fix-metrics;
            };
            method = mkOption {
              type = types.str;
              default = defaultSettings.gpu-usage.method; # "busy-flag" or "process"
            };
            flush-every = mkOption {
              type = types.int;
              default = defaultSettings.gpu-usage.flush-every;
            };
          };

          gpu = {
            set-method = mkOption {
              type = types.str;
              default = defaultSettings.gpu.set-method; # "smu" or "kernel"
            };
          };

          dbus = {
            enabled = mkOption {
              type = types.bool;
              default = defaultSettings.dbus.enabled;
            };
          };

          frequency-range = {
            min = mkOption {
              type = types.int;
              default = defaultSettings.frequency-range.min;
            };
            max = mkOption {
              type = types.int;
              default = defaultSettings.frequency-range.max;
            };
          };

          frequency-thresholds.adjust = mkOption {
            type = types.int;
            default = defaultSettings.frequency-thresholds.adjust;
          };

          load-target = {
            upper = mkOption {
              type = types.float;
              default = defaultSettings.load-target.upper;
            };
            lower = mkOption {
              type = types.float;
              default = defaultSettings.load-target.lower;
            };
          };

          temperature = {
            throttling = mkOption {
              type = types.int;
              default = defaultSettings.temperature.throttling;
            };
            throttling_recovery = mkOption {
              type = types.int;
              default = defaultSettings.temperature.throttling_recovery;
            };
          };

          safe-points = mkOption {
            type = types.listOf (
              types.submodule {
                options = {
                  frequency = mkOption {type = types.int;};
                  voltage = mkOption {type = types.int;};
                };
              }
            );
            default = defaultSettings.safe-points or [];
          };
        };
      };
      default = {};
    };
  };

  config = mkIf cfg.enable {
    systemd.services.cyan-skillfish-governor = {
      description = "Cyan skillfish Governor Service";
      after = ["multi-user.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.cyan-skillfish-governor}/bin/cyan-skillfish-governor-smu ${configFile}";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
