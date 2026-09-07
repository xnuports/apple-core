# plutil(1): ObjC, flags from foundation_cmds/plutil/Makefile.
T_CFLAGS+=	-fobjc-arc
T_LDADD+=	-framework Foundation -framework CoreFoundation -lobjc
