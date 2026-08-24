# tftp: the shared tftp-utils helper lives in the tftpd source dir.
# The tftp-*.c helpers (shared with tftpd) live in the tftpd dir.
T_SRCS=		main.c tftp.c \
		src/remote_cmds/tftpd/tftp-file.c \
		src/remote_cmds/tftpd/tftp-io.c \
		src/remote_cmds/tftpd/tftp-options.c \
		src/remote_cmds/tftpd/tftp-transfer.c \
		src/remote_cmds/tftpd/tftp-utils.c
T_CFLAGS+=	-I${TOP}/src/remote_cmds/tftp -I${TOP}/src/remote_cmds/tftpd
# interactive command loop uses libedit.
T_LDADD+=	-ledit
