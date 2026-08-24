# mk/with-libfsck_hfs.mk
#
# Link a tool against fsck_hfs' support library (built from the hfs
# submodule by lib/Makefile).  dfalib still uses the classic Mac Memory
# Manager API, so CarbonCore's headers are needed too.
SDKROOT_PATH!=	xcrun --show-sdk-path 2>/dev/null || echo /
CARBONCORE_HDRS=	${SDKROOT_PATH}/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/CarbonCore.framework/Versions/A/Headers

T_CFLAGS+=	-I${TOP}/src/hfs/lib_fsck_hfs -I${TOP}/src/hfs/lib_fsck_hfs/dfalib \
		-I${CARBONCORE_HDRS}
T_LDADD+=	${TOP}/build/lib/libfsck_hfs.a
