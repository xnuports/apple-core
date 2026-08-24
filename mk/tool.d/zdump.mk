# zdump shares tzcode headers with zic.
# USE_LTZ=0 -> zdump uses its own localtime_rz/tzalloc shims; no tzcode lib needed.
T_CFLAGS+=	-I${TOP}/include/tzcode -DUSE_LTZ=0
