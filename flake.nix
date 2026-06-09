{
  description = "Add support for BC250 (oberon) to NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: {
    overlays = {
      default = final: prev: {
        cyan-skillfish-governor = final.callPackage ./packages/cyan-skillfish-governor.nix {};
      };
    };
    nixosModules = {
      default = import ./modules;
    };
  };
}
