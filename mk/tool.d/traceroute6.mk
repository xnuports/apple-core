# traceroute6 reuses traceroute's AS-number lookup backend (as.c/as.h)
# since Apple ships those only in the traceroute.tproj directory.

T_CFLAGS+=	-I${TOP}/src/network_cmds/traceroute.tproj

# selects RFC 3542 IPV6_* option names in <netinet/in6.h>
T_CFLAGS+=	-D__APPLE_USE_RFC_3542
# legacy RFC 2292 option name used by the non-3542 code path
T_CFLAGS+=	-DIPV6_PKTOPTIONS=19

# out-of-tree source: path relative to TOP, handled by mk/tool.mk
T_SRCS=		traceroute6.c src/network_cmds/traceroute.tproj/as.c

.include "${TOP}/mk/with-netcmds.mk"

# libpcap for create_pcap_on_interface()
T_LDADD+=	-lpcap
