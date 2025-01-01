final: prev {
  oberon-governor = prev.callPackage ./packages/oberon-governor.nix { };

  mesa = prev.mesa.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [ ./patches/mesa_bc250.patch ];
  });
}
