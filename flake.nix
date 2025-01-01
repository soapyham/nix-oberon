{
  description = "Add support for BC250 (oberon) to NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, ... }: {
    #nixpkgs.overlays = [ ./overylay.nix ];

    overlays.default = import ./overlay.nix;

    nixosModules = rec {
      oberon = import ./modules/oberon.nix {};
      oberon-governor = import ./modules/oberon-governor.nix {};
      default = oberon;
    };
  };
}
