{stdenv, fetchurl}:

assert stdenv.isLinux;

let version = "2.6.26.2"; in 

stdenv.mkDerivation {
  name = "linux-headers-${version}";
  
  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v2.6/linux-${version}.tar.bz2";
    sha256 = "0xrkv6wk5l4qhza35a76cd00a7g9xv3ymw7znwskig2kmqswnp1m";
  };

  platform = 
    if stdenv.system == "i686-linux" then "i386" else
    if stdenv.system == "x86_64-linux" then "x86_64" else
    if stdenv.system == "powerpc-linux" then "powerpc" else
    abort "don't know what the kernel include directory is called for this platform";

  # !!! hacky
  fixupPhase = "ln -s $out/include/asm $out/include/asm-$platform";

  extraIncludeDirs =
    if stdenv.system == "powerpc-linux" then ["ppc"] else [];

  patchPhase = ''
    sed -i '/scsi/d' include/Kbuild
  '';

  buildPhase = ''
    make mrproper headers_check
  '';

  installPhase = ''
    make INSTALL_HDR_PATH=$out headers_install

    # Some builds (e.g. KVM) want a kernel.release.
    ensureDir $out/include/config
    echo "${version}-default" > $out/include/config/kernel.release
  '';
}
