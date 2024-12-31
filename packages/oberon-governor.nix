{ lib, stdenv, fetchFromGitLab, cmake, libdrm, pkg-config }:
stdenv.mkDerivation rec {
  pname = "oberon-governor";
  version = "0.1";

  src = fetchFromGitLab {
    owner = "TuxThePenguin0";
    repo = "oberon-governor";
    rev = "bbbc7b4d06b862f0f0a050840fbadaa6f3a49003";
    sha256 = "sha256-q4MNy1tVXDNo3oliI6KV5a6IgmwSGLgYITzBA6Hk12I=";
  };

  patches = [ ../patches/oberon-governor.patch ];

  nativeBuildInputs = [ pkg-config cmake libdrm ];

  dontFixCmake = true;

  #cmakeFlags = [
  #  "-DCMAKE_INSTALL_PREFIX=${out}"
  #];

  outputs = [ "out" ];

  meta = with lib; {
    description =
      "A simple daemon for AMD Oberon based systems that automatically governs GPU voltage and frequency based on load and temperature.";
    homepage = "https://gitlab.com/TuxThePenguin0/oberon-governor";
    license = licenses.mit;
  };
}
