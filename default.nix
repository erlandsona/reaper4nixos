# `nix-build` then run `result/bin/reaper`

with import <nixpkgs> {};

let
  # REAPER/linux - this is an unsupported experimental version.
  # Requirements:
  #   + libc6, libstdc++ for gcc 4.x or later
  #   + libgdk-3 (you can also target headless or libgdk-2 if you build your own libSwell from WDL)

  # Supported architectures (so far):
  #   + x86_64
  #   + i686 (with SSE2)
  #   + ARM with Thumb2+ and VFP (Raspberry Pi 2 or later, Chromebooks)

  # Other notes:
  #   + If text does not look right, install dejavu or cantarell:
  #     sudo apt-get install fonts-dejavu
  #       or
  #     sudo apt-get install fonts-cantarell

  libPath = lib.makeLibraryPath [ alsaLib gcc.cc xlibs.libX11 xlibs.libXi gnome3.gtk ];
  reaper-drv = stdenv.mkDerivation {
    name = "reaper-drv";
    src = fetchurl {
      url = "https://landoleet.org/old/reaper575preARA6_linux_x86_64.tar.xz";
      sha256 = "0dg1584qpkri8ydjbq0kr22k4irg0npza963rv7ydzpyfv51v376";
    };
    installPhase = ''
      tar -xf $src
      cp -r reaper_linux_x86_64/REAPER $out/
      cd $out

      mkdir bin lib
      mv reaper5 reamote-server bin/
      mv libSwell.so bin/
      mkdir -pv share/reaper
      mv whatsnew.txt tips.txt Resources Plugins license.txt InstallData Docs share/reaper/

      patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath ${libPath} bin/reaper5
      patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath ${libPath} bin/reamote-server
      patchelf --set-rpath ${libPath} bin/libSwell.so
    '';
    dontStrip = true;
  };
in buildFHSUserEnv {
  name = "reaper";
  targetPkgs = pkgs: [ reaper-drv ];
  runScript = "reaper5";
}
