# traceroute links against network_cmds_lib helpers and libpcap.
.include "${TOP}/mk/with-netcmds.mk"
T_LDADD+=	-lpcap
