# reboot: talks to kextd over the kextmanager MIG interface to take the
# reboot lock.  kextmanager.h/kextmanagerUser.c are generated from the
# in-tree kextmanager.defs (see mk/with-kextmanager.mk).
#
# T_SRCS is listed explicitly because with-kextmanager.mk appends the
# generated user stub, which would otherwise disable source discovery.
T_SRCS=		reboot.c
.include "${TOP}/mk/with-kextmanager.mk"
T_LDADD+=	-framework IOKit -framework CoreFoundation
