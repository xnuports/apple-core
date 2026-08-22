# mk/tool.mk
#
# Per-program build driver.  Not meant to be invoked by hand;
# src/Makefile recurses into this file once per entry of mk/progs.mk:
#
#	bmake -f mk/tool.mk TOP=<repo> T_DIR=shell_cmds/date \
#	                     T_PROG=date T_BIN=bin
#
# Sources live inside immutable submodules; every Makefile lives
# outside them and reaches in read-only.
#
# Optional per-tool customization belongs in mk/tool.d/<program>.mk,
# safely included when present.  Recognized knobs:
#
#	T_SRCS		override source list (basenames)
#	T_CFLAGS	extra compiler flags
#	T_LDADD		extra libraries (e.g. -lpam, ${LIBUTIL})
#	T_NOBUILD	set to any value to turn the entry into a no-op

.if defined(T_NOBUILD)
all clean:
	@${ECHO} "skip: ${T_PROG} (T_NOBUILD)"
.else

TOP?=		${.CURDIR}
T_SRCDIR?=	${TOP}/src/${T_DIR}
T_OBJDIR?=	${TOP}/build/obj/${T_DIR}
T_TARGET?=	${TOP}/build/release/${T_BIN}/${T_PROG}

.include "${TOP}/mk/darwintools.sys.mk"

.PATH: ${T_SRCDIR}

# ------------------------------------------------------------------
# Source discovery
#
# Default: every .c/.y/.l file in the tool directory.  Yacc and lex
# inputs are expanded to their generated C sources up front so the
# rest of the file deals only in compilable sources.
# ------------------------------------------------------------------
.if !defined(T_SRCS)
_RAW!=		ls ${T_SRCDIR}/*.c ${T_SRCDIR}/*.y ${T_SRCDIR}/*.l 2>/dev/null || true
SRCS!=		for f in ${_RAW}; do basename "$$f"; done 2>/dev/null || true
.endif

_GEN=
.for s in ${SRCS}
. if !empty(s:M*.y)
_GEN+=		${s:T:R}.tab.c
. elif !empty(s:M*.l)
_GEN+=		${s:T}.lex.c
. else
_GEN+=		${s:T}
. endif
.endfor

OBJS=
.for g in ${_GEN}
. if !empty(g:M*.tab.c)
OBJS+=		${T_OBJDIR}/${g:R:S/\.tab$//}.tab.o
. elif !empty(g:M*.lex.c)
OBJS+=		${T_OBJDIR}/${g:R}.o
. else
OBJS+=		${T_OBJDIR}/${g:R}.o
. endif
.endfor

# ------------------------------------------------------------------
# Rules -- objects compile straight into T_OBJDIR so builds never
# write inside the submodules.  bmake does not apply suffix transforms
# to objdir-qualified targets, so every rule is spelled out.
# ------------------------------------------------------------------

all: ${T_TARGET}
	@${ECHO} "built: ${T_BIN}/${T_PROG}"

${T_OBJDIR} ${T_TARGET:H}:
	@mkdir -p ${.TARGET}

.for s in ${SRCS}
. if !empty(s:M*.y)
# Yacc: foo.y -> foo.tab.c + foo.tab.h -> foo.tab.o
${T_OBJDIR}/${s:T:R}.tab.c ${T_OBJDIR}/${s:T:R}.tab.h: ${T_SRCDIR}/${s}
	@mkdir -p ${T_OBJDIR}
	cd ${T_OBJDIR} && ${YACC} -d ${T_SRCDIR}/${s}

${T_OBJDIR}/${s:T:R}.tab.o: ${T_OBJDIR}/${s:T:R}.tab.c ${T_OBJDIR}/${s:T:R}.tab.h
	${CC} ${CPPFLAGS} -I${T_OBJDIR} ${CFLAGS} ${T_CFLAGS} -c ${T_OBJDIR}/${s:T:R}.tab.c -o ${.TARGET}
. elif !empty(s:M*.l)
# Lex: foo.l -> foo.l.lex.c -> foo.l.lex.o
${T_OBJDIR}/${s:T}.lex.c: ${T_SRCDIR}/${s}
	@mkdir -p ${T_OBJDIR}
	${LEX} -t ${T_SRCDIR}/${s} > ${.TARGET}

${T_OBJDIR}/${s:T}.lex.o: ${T_OBJDIR}/${s:T}.lex.c
	${CC} ${CPPFLAGS} ${CFLAGS} ${T_CFLAGS} -c ${.IMPSRC} -o ${.TARGET}
. else
# Plain C source.
${T_OBJDIR}/${s:T:R}.o: ${T_SRCDIR}/${s}
	@mkdir -p ${T_OBJDIR}
	${CC} ${CPPFLAGS} ${CFLAGS} ${T_CFLAGS} -c ${.ALLSRC} -o ${.TARGET}
. endif
.endfor

# Per-tool fragment comes after defaults so it can override anything.
sinclude ${TOP}/mk/tool.d/${T_PROG}.mk

${T_TARGET}: ${OBJS}
	@mkdir -p ${.TARGET:H}
	${CC} -o ${.TARGET} ${OBJS} ${LDFLAGS} ${T_LDADD}

clean:
	rm -rf ${T_OBJDIR} ${T_TARGET}

.endif
