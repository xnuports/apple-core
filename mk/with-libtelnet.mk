# mk/with-libtelnet.mk
#
# Link a tool against our crypto-free libtelnet (option-negotiation
# helpers).  -I lib resolves the <libtelnet/*.h> includes.
T_CFLAGS+=	-I${TOP}/lib
T_LDADD+=	${TOP}/build/lib/libtelnet.a
