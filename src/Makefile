# src/Makefile
#
# Drives the build of every program listed in mk/progs.mk by
# recursing into mk/tool.mk once per entry.  The three fields of each
# entry map round-robin onto d (source dir), p (program name) and
# b (release suffix).

TOP?=		${.CURDIR}

.include "${TOP}/mk/darwintools.sys.mk"
.include "${TOP}/mk/progs.mk"

all:
.for d p b in ${PROGS}
.if empty(DISABLED_PROGS:M${p})
	-@${MAKE} -f ${TOP}/mk/tool.mk TOP=${TOP} \
		T_DIR=${d} T_PROG=${p} T_BIN=${b}
.endif
.endfor

clean:
.for d p b in ${PROGS}
.if empty(DISABLED_PROGS:M${p})
	-@${MAKE} -f ${TOP}/mk/tool.mk TOP=${TOP} \
		T_DIR=${d} T_PROG=${p} T_BIN=${b} clean
.endif
.endfor

list-progs:
.for d p b in ${PROGS}
.if empty(DISABLED_PROGS:M${p})
	@${ECHO} "${b}/${p}\t<- src/${d}"
.endif
.endfor
