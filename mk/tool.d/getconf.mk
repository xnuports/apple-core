# getconf(1): tables are generated from gperf-style inputs by the
# fake-gperf.awk helper (mirrors Apple's xcodebuild shell phase).
GPERFS=		confstr limits pathconf progenv sysconf unsigned_limits
T_SRCS=		getconf.c ${GPERFS:@g@build/gen/getconf/$g.c@}
T_CFLAGS+=	-I${T_SRCDIR}

.for g in ${GPERFS}
${TOP}/build/gen/getconf/$g.c: ${T_SRCDIR}/$g.gperf
	@mkdir -p ${.TARGET:H}
	LC_ALL=C awk -f ${T_SRCDIR}/fake-gperf.awk ${.ALLSRC} > ${.TARGET}
.endfor
