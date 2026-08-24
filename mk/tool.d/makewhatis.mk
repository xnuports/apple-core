# makewhatis needs the private System/sys/codesign.h (vendored from xnu).
T_CFLAGS+=	-I${TOP}/include -I${TOP}/include/System
# reads gzipped man pages.
T_LDADD+=	-lz
