# install(1) with digest support (no RIPEMD160 on Apple).
T_CFLAGS+=	-DWITH_DIGESTS -DWITH_MD5 -Wno-deprecated-declarations
