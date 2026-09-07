# tiffutil(1)
#
# BLOCKED: tiffdump_wrapper.c #includes libtiff's *source* file
# tools/tiffdump.c (via LOCAL_TIFFDUMP_PATH) to reuse its main() as
# tiffdump_file(), and tiffutil.m calls that.  A libtiff *installation* is not
# enough -- homebrew ships headers and a library, not the tools sources -- so
# this needs a libtiff source checkout, which the tool's own Makefile fetches
# and builds with CMake into .libtiff/.
#
# Point LOCAL_TIFFDUMP_PATH at a libtiff source tree and drop T_NOBUILD; the
# flags below are already right for the rest of the build.
T_NOBUILD=	yes

TIFF_CFLAGS!=	pkg-config --cflags libtiff-4 2>/dev/null || true
TIFF_LIBS!=	pkg-config --libs libtiff-4 2>/dev/null || echo -ltiff

T_CFLAGS+=	-fobjc-arc ${TIFF_CFLAGS}
T_LDADD+=	-framework Foundation -lobjc ${TIFF_LIBS}
