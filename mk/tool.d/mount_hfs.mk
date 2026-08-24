# mount_hfs: getmntopts()/mntopts.h come from our libutil; -F reaches the
# vendored framework headers (it uses the framework-style
# <DiskImages2/DICommon.h> spelling -- see that placeholder for why the
# framework itself is not needed).
T_CFLAGS+=	-F${TOP}/frameworks
.include "${TOP}/mk/with-libutil.mk"
T_LDADD+=	-framework IOKit -framework CoreFoundation
