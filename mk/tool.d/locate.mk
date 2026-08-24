# locate: the main binary lives in the locate/ subdir.  locate.c #includes
# fastfind.c directly (the classic locate idiom for its search variants),
# so only locate.c and util.c are compiled.
T_SRCS=		src/shell_cmds/locate/locate/locate.c \
		src/shell_cmds/locate/locate/util.c
T_CFLAGS+=	-I${TOP}/src/shell_cmds/locate/locate
