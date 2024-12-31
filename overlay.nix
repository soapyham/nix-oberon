final: prev: rec {
  oberon-governor = final.callPackage ./packages/oberon-governor.nix { };

  mesa = prev.mesa.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [ ./patches/mesa_bc250.patch ];
  });
}
