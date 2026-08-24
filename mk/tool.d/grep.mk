# grep: file.c transparently decompresses via liblzma/zlib/bzip2.
# lzma.h is our vendored interface header; the libs come from the SDK.
#
# BLOCKED: grep uses the full liblzma API, so the vendored single
# include/liblzma/lzma.h is insufficient -- it #includes lzma/version.h,
# lzma/base.h, ... which are not staged (absent from the SDK).  Stage the
# full lzma/ header tree, or build grep WITHOUT_LZMA, to finish this.
T_CFLAGS+=	-I${TOP}/include/liblzma
T_LDADD+=	-llzma -lz -lbz2
