{ config, pkgs, lib, ... }: {
  imports = [ ./oberon.nix ./oberon-governor.nix ];
}
