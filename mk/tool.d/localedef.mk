# localedef -- locale compiler (FreeBSD).  Bundles its own <sys/tree.h>
# and a set of libc locale headers; the grammar (parser.y) is compiled
# with yacc into parser.c/parser.h (the sources include "parser.h", not
# the .tab.h name tool.mk's generic yacc rule would produce).

LDEF=		src/adv_cmds/localedef
LDEF_GEN=	${TOP}/build/gen/localedef

T_SRCS=		charmap.c collate.c ctype.c localedef.c messages.c \
		monetary.c numeric.c scanner.c time.c wide.c \
		build/gen/localedef/parser.c

# -I localedef: bundled <sys/tree.h>.  -I libc: the locale headers.
# -I gen: the generated parser.h.
T_CFLAGS+=	-I${TOP}/${LDEF} -I${TOP}/${LDEF}/libc -I${LDEF_GEN}

# --- grammar (yacc -d, renamed to parser.c/parser.h) -----------------
${LDEF_GEN}/parser.c ${LDEF_GEN}/parser.h: ${TOP}/${LDEF}/parser.y
	@mkdir -p ${LDEF_GEN}
	cd ${LDEF_GEN} && ${YACC} -d ${TOP}/${LDEF}/parser.y && \
	    mv y.tab.c parser.c && mv y.tab.h parser.h

# Every object includes the generated parser.h, so make it a prerequisite
# to force codegen before any compile.
.for s in ${T_SRCS}
${T_OBJDIR}/${s:T:R}.o: ${LDEF_GEN}/parser.h
.endfor
