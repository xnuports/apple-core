# shutdown: talks to kextd over the kextmanager MIG interface to take the
# reboot lock (see mk/with-kextmanager.mk), and writes BSM audit records
# for the shutdown event.
#
# T_SRCS is listed explicitly because with-kextmanager.mk appends the
# generated user stub, which would otherwise disable source discovery.
T_SRCS=		shutdown.c
.include "${TOP}/mk/with-kextmanager.mk"
T_LDADD+=	-framework IOKit -framework CoreFoundation -lbsm
