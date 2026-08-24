# netstat links against network_cmds_lib helpers.
# unlocks PRIVATE sections in xnu headers (if_mib.h et al.)
T_CFLAGS+=	-DPRIVATE
# inet.c gates its v6 paths (and file-static done flags) on INET6
T_CFLAGS+=	-DINET6
# ipsec tables are compiled in on stock builds
T_CFLAGS+=	-DIPSEC
# newer clang promotes these to hard errors; upstream code predates that
T_CFLAGS+=	-Wno-int-conversion

.include "${TOP}/mk/with-netcmds.mk"

