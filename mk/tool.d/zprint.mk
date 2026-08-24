# zprint includes <vm_statistics.h> unprefixed and <libutil.h>.
T_CFLAGS+=	-I${TOP}/include/mach -DKERNEL_PRIVATE
.include "${TOP}/mk/with-libutil.mk"
T_LDADD+=	-framework IOKit -framework CoreFoundation -F/System/Library/PrivateFrameworks -framework CoreSymbolication
