# fsck_fskit: a thin front end onto FSKit; invoke_tool_from_fskit() comes from
# mk/compat/fskit_stub.c rather than disklib/fskit_support.m (see that
# file for why).
T_SRCS=		fsck_fskit.c mk/compat/fskit_stub.c
T_CFLAGS+=	-I${TOP}/src/diskdev_cmds/disklib
