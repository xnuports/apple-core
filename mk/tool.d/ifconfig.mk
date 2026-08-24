# ifconfig: uses ~58 extended (PRIVATE) SIOC* ioctls.  The public
# <sys/sockio.h> only pulls in <sys/sockio_private.h> under PRIVATE, and
# the SDK strips that include, so force-include our staged private header
# and compile with -DPRIVATE.
#
# BLOCKED: version skew.  The network_cmds ifconfig source is newer than
# the xnu headers available in the mSL-XNU tree -- ifconfig.c references
# netem fields/enums (IF_NETEM_MODEL_IOD/FPD, if_netem_params.
# ifnetem_reordering_ms) that exist only in the current SDK's
# Kernel.framework net/if_var_private.h, not in the staged headers.
# Finishing ifconfig needs a version-matched userland xnu header set.
T_CFLAGS+=	-DPRIVATE -include ${TOP}/include/sys/sockio_private.h
