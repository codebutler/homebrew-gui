class Inkscape < Formula
  desc "Professional vector graphics editor"
  homepage "https://inkscape.org/"
  url "https://inkscape.org/gallery/item/10552/inkscape-0.92.0.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/i/inkscape/inkscape_0.92.orig.tar.gz"
  sha256 "b8b4c159a00448d465384533e5a70d3f33e5f9c6b74c76ea5d636ddd6dd7ba56"

  option "with-gtk3", "Build Inkscape with GTK+3 (Experimental)"

  bottle do
    sha256 "ee5064b2c82543cb0edb8f0bc18b31218acf736e150023a4ae0f715191aaf54c" => :el_capitan
    sha256 "fd736662bb632af27e49999f0e8a5b6c403d6ea647cc6d9e91d72aebc467e216" => :yosemite
    sha256 "001db36d070bffe3697ed02472fb8ab670589734142600fa4af7f3e22e6fc380" => :mavericks
  end

  head do
    url "lp:inkscape", :using => :bzr
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost-build" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "poppler" => :optional
  depends_on "bdw-gc"
  depends_on "boost"
  depends_on "cairomm"
  depends_on "gettext"
  depends_on "glibmm"
  depends_on "gsl"
  depends_on "hicolor-icon-theme"
  depends_on "little-cms"
  depends_on "pango"
  depends_on "popt"

  depends_on "gtkmm3" if build.with? "gtk3"
  depends_on "gdl" if build.with? "gtk3"
  depends_on "gtkmm" if build.without? "gtk3"

  needs :cxx11

  if MacOS.version < :mavericks
    fails_with :clang do
      cause "inkscape's dependencies will be built with libstdc++ and fail to link."
    end
  end

  def install
    ENV.cxx11
    ENV.append "LDFLAGS", "-liconv"

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-strict-build
      --enable-lcms
      --without-gnome-vfs
    ]
    args << "--disable-poppler-cairo" if build.without? "poppler"
    args << "--enable-gtk3-experimental" if build.with? "gtk3"

    system "./autogen.sh"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/inkscape", "-x"
  end
end
