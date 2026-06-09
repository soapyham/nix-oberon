{
  self,
  nixpkgs,
  ...
}: {
  imports = [
    ./oberon.nix
    ./cyan-skillfish-governor.nix
  ];
}
