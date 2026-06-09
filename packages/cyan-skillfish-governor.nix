{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkgs,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "cyan-skillfish-governor";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "filippor";
    repo = "cyan-skillfish-governor";
    rev = "v${version}";
    hash = "sha256-Z9PBXUCAVquTVXfZRxLvEEQFD1AQ9eHwTvTuUJG8d/Y=";
  };

  cargoHash = "sha256-2CFDNnKGi1fqFKv9RU6lovNHm+LQMBV7ypxbNcbeR6w=";
  buildInputs = with pkgs; [
    libdrm
  ];

  postInstall = ''
    install -m755 -D default-config.toml $out/bin/default-config.toml
  '';

  meta = with lib; {
    description = "GPU governor for the AMD Cyan Skillfish APU ";
    homepage = "https://github.com/filippor/cyan-skillfish-governor";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.linux;
  };
}
