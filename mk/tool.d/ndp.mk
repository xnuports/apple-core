# ndp uses the same private routing/traffic-class constants as the rest
# of network_cmds.
.include "${TOP}/mk/with-netcmds.mk"

# ndp.c predates stricter int-conversion diagnostics
T_CFLAGS+=	-Wno-error=int-conversion
