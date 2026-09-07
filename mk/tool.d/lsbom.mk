# lsbom(1): one of three tools in the flat BomCmds directory.  Links the
# private Bom framework, as BomCmds/Makefile does.
T_SRCS=		lsbom.c
T_LDADD+=	-framework CoreFoundation -F/System/Library/PrivateFrameworks -framework Bom
