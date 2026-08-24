# ping6 needs network_cmds_lib helpers and RFC 3542 IPV6_* names.
.include "${TOP}/mk/with-netcmds.mk"
T_CFLAGS+=	-D__APPLE_USE_RFC_3542
# in6_private.h (IPV6_NO_IFT_CELLULAR) must come via netinet/in_private.h
T_CFLAGS+=	-include ${TOP}/include/netinet/in_private.h

# legacy RFC 2292 option name used by the non-3542 code path
T_CFLAGS+=	-DIPV6_PKTOPTIONS=19
