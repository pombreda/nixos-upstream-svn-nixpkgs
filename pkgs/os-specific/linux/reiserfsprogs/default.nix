args: with args;

stdenv.mkDerivation {
  name = "reiserfsprogs-3.6.19";
  src = fetchurl {
      url = ftp://ftp.namesys.com/pub/reiserfsprogs/reiserfsprogs-3.6.19.tar.gz;
      sha256 = "1gv8gr0l5l2j52540y2wj9c9h7fn0r3vabykf95748ydmr9jr1n0";
    };

  homepage=http://www.namesys.com/;

  description="Reiserfs Utilities";

  license="GPL-2";
}