# ifconfig: uses ~58 extended (PRIVATE) SIOC* ioctls.  The public
# <sys/sockio.h> only pulls in <sys/sockio_private.h> under PRIVATE, and the
# SDK strips that include, so force-include our staged private header.
#
# Its netem support is newer than the xnu headers vendored here: it needs
# struct if_netem_params.ifnetem_reordering_ms, which only the SDK's
# Kernel.framework copy of net/if_var_private.h has.  Force-include that copy
# first -- both share the _NET_IF_VAR_PRIVATE_H_ guard, so the older staged
# one becomes a no-op for this tool while netstat keeps using it.
#
# The two remaining model enumerators appear in no published header and are
# recovered from Apple's shipped /sbin/ifconfig; see
# include/net/if_netem_models_private.h.
SDKROOT_PATH!=	xcrun --show-sdk-path 2>/dev/null || echo /
KERNEL_HDRS=	${SDKROOT_PATH}/System/Library/Frameworks/Kernel.framework/Versions/A/Headers

T_CFLAGS+=	-DPRIVATE \
		-include ${KERNEL_HDRS}/net/if_var_private.h \
		-include ${TOP}/include/net/if_netem_models_private.h \
		-include ${TOP}/include/sys/sockio_private.h
