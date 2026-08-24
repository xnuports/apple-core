# quotacheck: blockcheck() lives in the shared disklib preen helper.
T_SRCS=		quotacheck.c hfs_quotacheck.c \
		src/diskdev_cmds/disklib/preen.c
T_CFLAGS+=	-I${TOP}/src/diskdev_cmds/disklib
