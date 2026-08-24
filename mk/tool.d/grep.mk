# grep: file.c transparently decompresses via liblzma/zlib/bzip2.  The full
# liblzma API header tree is vendored under include/liblzma; the libs come
# from the SDK (.tbd).
T_CFLAGS+=	-I${TOP}/include/liblzma
T_LDADD+=	-llzma -lz -lbz2
