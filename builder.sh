source $stdenv/setup
# PATH=$tar/bin:$PATH
tar -xf $src
cp -r reaper_linux_x86_64/REAPER $out/
