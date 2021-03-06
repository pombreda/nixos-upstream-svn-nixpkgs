args : 
let 
  lib = args.lib;
  fetchurl = args.fetchurl;
  FullDepEntry = args.FullDepEntry;

  version = lib.getAttr ["version"] "9.4" args; 
  buildInputs = with args; [gtk glib pkgconfig 
     libXpm gmp gettext libX11 fftw]
      ++ (lib.optional (args ? ruby) args.ruby)
      ++ (lib.optional (args ? mesa) args.mesa)
      ++ (lib.optional (args ? guile) args.guile)
      ++ (lib.optional (args ? libtool) args.libtool)
      ++ (lib.optional (args ? sndlib) args.sndlib)
      ++ (lib.optional (args ? alsaLib) args.alsaLib)
      ++ (lib.optional (args ? jackaudio) args.jackaudio)
      ;
  configureFlags = ["--with-gtk" "--with-xpm"]
    ++ (lib.optional (args ? ruby)   "--with-ruby" )
    ++ (lib.optional (args ? mesa)   "--with-gl"   )
    ++ (lib.optional (args ? guile)  "--with-guile")
    ++ (lib.optional (args ? sndlib) "--with-midi" )
    ++ (lib.optional (args ? alsaLib)  "--with-alsa")
    ++ (lib.optional (args ? jackaudio) "--with-jack" )
    ++ [ "--with-fftw" "--htmldir=$out/share/snd/html" "--with-doc-dir=$out/share/snd/html" ]
    ;
in
rec {
  src = fetchurl {
    url = "http://downloads.sourceforge.net/snd/snd-${version}.tar.gz";
    sha256 = "0zqgfnkvkqxby1k74mwba1r4pb520glcsz5jjmpzm9m41nqnghmm";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "preBuild" "makeDocsWork" 
    "doMakeInstall" "doForceShare"];

  makeDocsWork = FullDepEntry ''
                # hackish way to make html docs work
                h="$out/share/snd/html"; ensureDir "$h"; cp *.html "$h"
                patch -p1 < ${./doc.patch}
                sed "s@HTML-DIR@$h@" -i index.scm snd-help.c
            '' ["defEnsureDir"];

  preBuild = FullDepEntry (''
		cp config.log /tmp/snd-config.log
		export NIX_LDFLAGS="$NIX_LDFLAGS -L${args.libX11}/lib -lX11"
                
            '') ["minInit" "doUnpack" "makeDocsWork"];

  name = "Snd-" + version;
  meta = {
    description = "Snd sound editor.";
    homepage = http://ccrma.stanford.edu/software/snd;
    inherit src;
  };
}
