# mk/with-libutil.mk
#
# Shared fragment: include from a tool's mk/tool.d/<prog>.mk to build
# against our lib/libutil static library.
#
#	T_CFLAGS+= -I${TOP}/lib/libutil
#	T_LDADD+=  ${TOP}/build/lib/libutil.a

T_CFLAGS+=	-I${TOP}/lib/libutil
T_LDADD+=	${TOP}/build/lib/libutil.a
