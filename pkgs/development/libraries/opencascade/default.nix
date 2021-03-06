{stdenv, fetchurl, mesa, qt4, tcl, tk}:

stdenv.mkDerivation {
  name = "opencascade-6.3.0";
  src = fetchurl {
    url = http://files.opencascade.com/OCC_6.3_release/OpenCASCADE_src.tgz;
    md5 = "52778127974cb3141c2827f9d40d1f11";
  };

  buildInputs = [ mesa qt4 tcl tk];

  preConfigure = "cd ros";

  meta = {
    description = "Open CASCADE Technology, libraries for 3D modeling and numerical simulation";
    homepage = http://www.opencascade.org/;
  };
}
