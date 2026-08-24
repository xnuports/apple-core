# mount: needs the in-tree helpers (edt_fstab, disklib's vfslist, the
# shared mount_flags optnames table) plus the APFS private framework
# headers vendored under frameworks/ (-F, since mount.c uses the
# framework-style <APFS/APFS.h> spelling).
#
# invoke_tool_from_fskit() comes from mk/compat/fskit_stub.c rather than
# disklib/fskit_support.m -- see that file for why.
T_SRCS=		mount.c mount_tmpfs.c \
		src/diskdev_cmds/edt_fstab/edt_fstab.c \
		src/diskdev_cmds/disklib/vfslist.c \
		src/diskdev_cmds/mount_flags_dir/mount_flags.c \
		mk/compat/fskit_stub.c
T_CFLAGS+=	-F${TOP}/frameworks \
		-I${TOP}/src/diskdev_cmds/edt_fstab \
		-I${TOP}/src/diskdev_cmds/disklib \
		-I${TOP}/src/diskdev_cmds/mount_flags_dir \
		-I${TOP}/src/diskdev_cmds/fsck.tproj
# mount.c passes NULL for sysctlbyname()'s size_t newlen argument, which
# newer clang promotes from warning to error.  NULL is 0 here, i.e. the
# intended "no new value", so keep it a warning rather than patch the
# submodule source.
T_CFLAGS+=	-Wno-int-conversion
.include "${TOP}/mk/with-libutil.mk"
T_LDADD+=	-framework CoreFoundation -framework IOKit
