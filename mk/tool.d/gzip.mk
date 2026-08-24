# gzip(1) build settings.
# No system liblzma on Darwin; disable xz support (Apple builds it with
# an internal liblzma, we skip it until a vendored alternative exists).
T_CFLAGS+=	-DNO_XZ_SUPPORT
# Apple version string from the upstream xcconfig (RC_ProjectSourceVersion).
T_CFLAGS+=	-DGZIP_APPLE_VERSION='"153"'
# unbzip2.c is #included by gzip.c, not a standalone TU; futimens is
# provided by libc on modern Darwin but the compat TU still builds.
T_SRCS+=	gzip.c futimens.c
# zlib for deflate/crc32, libbz2 for bzip2 decompression.
T_LDADD+=	-lz -lbz2
