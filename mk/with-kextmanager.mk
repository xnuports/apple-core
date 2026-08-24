# mk/with-kextmanager.mk
#
# kextmanager.h / kextmanagerUser.c are MIG-generated from the in-tree
# kextmanager.defs (which pulls in our staged IOKit/kext/kextmanager_mig.defs).
# Include from a tool fragment that talks to kextd.

KM_GEN=		${TOP}/build/gen/kextmanager

T_CFLAGS+=	-I${KM_GEN}
T_SRCS+=	build/gen/kextmanager/kextmanagerUser.c

${KM_GEN}/kextmanager.h ${KM_GEN}/kextmanagerUser.c: ${T_SRCDIR}/kextmanager.defs
	@mkdir -p ${KM_GEN}
	cd ${KM_GEN} && ${MIG} -I${TOP}/include \
		-user kextmanagerUser.c -header kextmanager.h -server /dev/null \
		${T_SRCDIR}/kextmanager.defs

.for s in ${T_SRCS}
${T_OBJDIR}/${s:T:R}.o: ${KM_GEN}/kextmanager.h
.endfor
