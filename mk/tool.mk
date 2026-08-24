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
#	T_LINKS		extra names hardlinked to the built binary in the
#			same install dir (e.g. dc -> bc)
#	T_NOBUILD	set to any value to turn the entry into a no-op
#
# Shell-script tools set T_SCRIPT=<script basename>; the script is
# installed to the target location with the executable bit set.

TOP?=		${.CURDIR}
T_SRCDIR?=	${TOP}/src/${T_DIR}
T_OBJDIR?=	${TOP}/build/obj/${T_DIR}
T_TARGET?=	${TOP}/build/release/${T_BIN}/${T_PROG}

.include "${TOP}/mk/darwintools.sys.mk"

# Per-tool fragment loads before everything so T_SRCS/T_SCRIPT/
# T_NOBUILD/etc. influence which branch below runs.
sinclude ${TOP}/mk/tool.d/${T_PROG}.mk

# `all` is always the default target, even when a fragment defines its
# own helper rules (e.g. codegen) that would otherwise come first.
.MAIN: all

.if defined(T_NOBUILD)
all clean:
	@${ECHO} "skip: ${T_PROG} (T_NOBUILD)"
.elif defined(T_SCRIPT)

# ------------------------------------------------------------------
# Script tool: install the named script as the program.
# ------------------------------------------------------------------

T_SCRIPTFILE?=	${T_SRCDIR}/${T_SCRIPT}

all: ${T_TARGET}
	@${ECHO} "built: ${T_BIN}/${T_PROG} (script)"

${T_TARGET}: ${T_SCRIPTFILE}
	@mkdir -p ${.TARGET:H}
	cp ${T_SCRIPTFILE} ${.TARGET}
	chmod 755 ${.TARGET}

clean:
	rm -f ${T_TARGET}

.else

# ------------------------------------------------------------------
# Compiled program.
# ------------------------------------------------------------------

.PATH: ${T_SRCDIR}

# ------------------------------------------------------------------
# Source resolution
#
# Explicit list wins (from mk/tool.d/<prog>.mk); otherwise discover
# every .c/.y/.l file in the tool directory.  Yacc and lex inputs are
# expanded to their generated C sources up front so the rest of the
# file deals only in compilable sources.
# ------------------------------------------------------------------
.if defined(T_SRCS)
SRCS=	${T_SRCS}
.else
_RAW!=		ls ${T_SRCDIR}/*.c ${T_SRCDIR}/*.cc ${T_SRCDIR}/*.cpp ${T_SRCDIR}/*.y ${T_SRCDIR}/*.l 2>/dev/null || true
SRCS!=		for f in ${_RAW}; do basename "$$f"; done 2>/dev/null || true
.endif

_GEN=
.for s in ${SRCS}
. if ${s:M*.y} != ""
_GEN+=		${s:T:R}.tab.c
. elif ${s:M*.l} != ""
_GEN+=		${s:T}.lex.c
. else
_GEN+=		${s:T}
. endif
.endfor

OBJS=
.for g in ${_GEN}
. if ${g:M*.tab.c} != ""
OBJS+=		${T_OBJDIR}/${g:C/\.tab.c$/.tab.o/}
. elif ${g:M*.lex.c} != ""
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
.for l in ${T_LINKS}
	ln -f ${T_TARGET} ${T_TARGET:H}/${l}
.endfor
	@${ECHO} "built: ${T_BIN}/${T_PROG}${T_LINKS:D (+${T_LINKS})}"

${T_OBJDIR} ${T_TARGET:H}:
	@mkdir -p ${.TARGET}

.for s in ${SRCS}
. if ${s:M*/*} != ""
# Source outside T_SRCDIR: T_SRCS entry is a path relative to TOP.
${T_OBJDIR}/${s:T:R}.o: ${TOP}/${s}
	@mkdir -p ${T_OBJDIR}
	${CC} ${CPPFLAGS} ${CFLAGS} ${T_CFLAGS} -c ${TOP}/${s} -o ${.TARGET}
. elif ${s:M*.y} != ""
# Yacc: foo.y -> foo.tab.c + foo.tab.h -> foo.tab.o
${T_OBJDIR}/${s:T:R}.tab.c ${T_OBJDIR}/${s:T:R}.tab.h: ${T_SRCDIR}/${s}
	@mkdir -p ${T_OBJDIR}
	cd ${T_OBJDIR} && ${YACC} -d ${T_SRCDIR}/${s} && \
	    mv y.tab.c ${s:T:R}.tab.c && mv y.tab.h ${s:T:R}.tab.h

${T_OBJDIR}/${s:T:R}.tab.o: ${T_OBJDIR}/${s:T:R}.tab.c ${T_OBJDIR}/${s:T:R}.tab.h
	${CC} ${CPPFLAGS} -I${T_OBJDIR} ${CFLAGS} ${T_CFLAGS} -c ${T_OBJDIR}/${s:T:R}.tab.c -o ${.TARGET}
. elif ${s:M*.l} != ""
# Lex: foo.l -> foo.l.lex.c -> foo.l.lex.o
${T_OBJDIR}/${s:T}.lex.c: ${T_SRCDIR}/${s}
	@mkdir -p ${T_OBJDIR}
	${LEX} -t ${T_SRCDIR}/${s} > ${.TARGET}

${T_OBJDIR}/${s:T}.lex.o: ${T_OBJDIR}/${s:T}.lex.c
	${CC} ${CPPFLAGS} ${CFLAGS} ${T_CFLAGS} -c ${.IMPSRC} -o ${.TARGET}
. elif ${s:M*.cc} != "" || ${s:M*.cpp} != ""
# C++ source.
${T_OBJDIR}/${s:T:R}.o: ${T_SRCDIR}/${s}
	@mkdir -p ${T_OBJDIR}
	${CXX} ${CPPFLAGS} ${CXXFLAGS} ${T_CFLAGS} -c ${.ALLSRC} -o ${.TARGET}
. else
# Plain C source.
${T_OBJDIR}/${s:T:R}.o: ${T_SRCDIR}/${s}
	@mkdir -p ${T_OBJDIR}
	${CC} ${CPPFLAGS} ${CFLAGS} ${T_CFLAGS} -c ${.ALLSRC} -o ${.TARGET}
. endif
.endfor

# Link with the C++ driver when any source is C++ (pulls libc++ in).
_LINKER=	${CC}
.for s in ${SRCS}
. if ${s:M*.cc} != "" || ${s:M*.cpp} != ""
_LINKER=	${CXX}
. endif
.endfor

${T_TARGET}: ${OBJS}
	@mkdir -p ${.TARGET:H}
	${_LINKER} -o ${.TARGET} ${OBJS} ${LDFLAGS} ${T_LDADD}

clean:
	rm -rf ${T_OBJDIR} ${T_TARGET}
.for l in ${T_LINKS}
	rm -f ${T_TARGET:H}/${l}
.endfor

.endif
