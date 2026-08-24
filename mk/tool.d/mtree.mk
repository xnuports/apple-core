# mtree uses CoreFoundation + cksum crc.c for the crc keyword.
T_CFLAGS+=	-I${T_SRCDIR}
T_LDADD+=	-framework CoreFoundation
T_SRCS=		commoncrypto.c compare.c create.c excludes.c metrics.c misc.c \
		mtree.c spec.c specspec.c verify.c \
		src/file_cmds/cksum/crc.c
