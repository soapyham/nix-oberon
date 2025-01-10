{
  description = "Add support for BC250 (oberon) to NixOS";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11"; };

  outputs = { self, nixpkgs, ... }: {
    overlays = {
      default = final: prev: {
        oberon-governor = prev.callPackage ./packages/oberon-governor.nix { };

        mesa = prev.mesa.overrideAttrs (oldAttrs: {
          version = "24.3.3";
          patches = oldAttrs.patches ++ [
            ./patches/mesa_bc250.patch # mesa: add support for BC250 https://gitlab.freedesktop.org/provod/mesa/-/merge_requests/3
            ./patches/mesa_bc250_raytracing.patch # radv: add has_raytracing flag to radeon_info https://gitlab.freedesktop.org/provod/mesa/-/merge_requests/2
          ];
        });
      };
    };
    nixosModules = { default = import ./modules; };
  };
}
