# sh -- the FreeBSD/Apple Almquist shell.
#
# Four files are generated at build time: syntax.{c,h} and nodes.{c,h}
# come from the host build-tools mksyntax/mknodes (compiled here and run),
# while builtins.{c,h} and token.h come from the mkbuiltins/mktokens
# shell scripts.  The echo/kill/test/printf builtins are borrowed (with
# -DSHELL) from their standalone tools, as in sh's own Makefile .PATH.

SH=		src/shell_cmds/sh
SHDIR=		${TOP}/${SH}
SH_GEN=		${TOP}/build/gen/sh

T_SRCS=		alias.c arith_yacc.c arith_yylex.c cd.c error.c eval.c \
		exec.c expand.c histedit.c input.c jobs.c mail.c main.c \
		memalloc.c miscbltin.c mystring.c options.c output.c parser.c \
		redir.c show.c trap.c var.c \
		src/shell_cmds/sh/bltin/echo.c \
		src/shell_cmds/kill/kill.c \
		src/shell_cmds/test/test.c \
		src/shell_cmds/printf/printf.c \
		build/gen/sh/builtins.c build/gen/sh/nodes.c build/gen/sh/syntax.c

T_CFLAGS+=	-DSHELL -I${SHDIR} -I${SH_GEN}
T_LDADD+=	-ledit

# Every object may include a generated header; force codegen to run first.
.for s in ${T_SRCS}
${T_OBJDIR}/${s:T:R}.o: ${SH_GEN}/builtins.h ${SH_GEN}/nodes.h \
			${SH_GEN}/syntax.h ${SH_GEN}/token.h
.endfor

# --- host build-tools -------------------------------------------------
${SH_GEN}/mksyntax: ${SHDIR}/mksyntax.c
	@mkdir -p ${SH_GEN}
	${CC} -I${SHDIR} ${SHDIR}/mksyntax.c -o ${SH_GEN}/mksyntax
${SH_GEN}/mknodes: ${SHDIR}/mknodes.c
	@mkdir -p ${SH_GEN}
	${CC} -I${SHDIR} ${SHDIR}/mknodes.c -o ${SH_GEN}/mknodes

# --- generated sources (each tool writes into its CWD = SH_GEN) --------
${SH_GEN}/syntax.c ${SH_GEN}/syntax.h: ${SH_GEN}/mksyntax
	cd ${SH_GEN} && ${SH_GEN}/mksyntax
${SH_GEN}/nodes.c ${SH_GEN}/nodes.h: ${SH_GEN}/mknodes ${SHDIR}/nodetypes ${SHDIR}/nodes.c.pat
	cd ${SH_GEN} && ${SH_GEN}/mknodes ${SHDIR}/nodetypes ${SHDIR}/nodes.c.pat
${SH_GEN}/builtins.c ${SH_GEN}/builtins.h: ${SHDIR}/mkbuiltins ${SHDIR}/builtins.def
	@mkdir -p ${SH_GEN}
	cd ${SH_GEN} && sh ${SHDIR}/mkbuiltins ${SHDIR}
${SH_GEN}/token.h: ${SHDIR}/mktokens
	@mkdir -p ${SH_GEN}
	cd ${SH_GEN} && sh ${SHDIR}/mktokens
