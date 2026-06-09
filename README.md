## How to use

Add this repo to the inputs section of your `flake.nix`:

```nix
{
  inputs = {
    nix-oberon.url = "github:soapyham/nix-oberon/master";
    inputs.nixpkgs.follows = "nixpkgs";
  }
}
```
Add the overlay

```nix
{
  outputs = { nix-oberon, ... }: {
    nixosConfigurations.example = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        (
          { pkgs, ... }:
          {
            nixpkgs.overlays = [
              nix-oberon.overlays.default
            ];
            services.oberon = {
              enable = false; # Enable the module
              unlock_cu = true; # EXPERIMENTAL: Apply kernel patch to unlock 40 cu
            };
          }
        )
      ];
    };
  };
}
```

The governor settings can be configured via the "settings". Refer to [config.toml](https://github.com/filippor/cyan-skillfish-governor/blob/smu/config.toml) for the default configuration. If not specified the default options will be used.

```nix
services.oberon = {
  settings = {
    load-target = {
      upper = 0.80;
      lower = 0.40;
    };
  };
};
```

TODO

Use cachyos-kernel
