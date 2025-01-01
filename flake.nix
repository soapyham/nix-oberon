{
  description = "Add support for BC250 (oberon) to NixOS";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11"; };

  outputs = { self, nixpkgs, ... }: {
    #nixpkgs.overlays = [ ./overylay.nix ];

    overlays.default = import ./overlay.nix;

    nixosModules = rec {
      default = self.nixosModules.oberon;
      oberon = import ./modules/oberon.nix;
      oberon.imports = [ ./modules/oberon-governor.nix ];
      #beron-governor = import ./modules/oberon-governor.nix;
    };
  };
}
