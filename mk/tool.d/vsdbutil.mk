# vsdbutil: the optnames[] mount-flag table lives in the shared
# mount_flags_dir object; kFSUUIDNamespaceSHA1 comes from our staged
# <System/uuid/namespace.h>.
T_SRCS=		vsdbutil_main.c \
		src/diskdev_cmds/mount_flags_dir/mount_flags.c
