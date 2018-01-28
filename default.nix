with import <nixpkgs> {};

let
  reaper-derivation = stdenv.mkDerivation {
    name = "reaper-derivation";
    builder = ./builder.sh;
    src = fetchurl {
      url = "https://landoleet.org/reaper571pre15_linux_x86_64.tar.xz";
      sha256 = "0i0djjal4kdqnpw3knhiplajkynbbd3f10d4hvh3l71v6rkpdhp2";
    };
  };

in rec {
  reaper = buildFHSUserEnv {
    name = "reaper";
    targetPkgs = pkgs: [ reaper-derivation ];
    /* runScript = "reaper5"; */
  };
}
