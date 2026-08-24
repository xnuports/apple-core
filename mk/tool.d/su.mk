# su: PAM auth + BSM audit session; login_cap comes from our libutil.
# <rootless.h> is staged from the internal SDK (SIP restricted-env check).
#
# BLOCKED: su.c also does `#import <SoftLinking/SoftLinking.h>` and
# SOFT_LINK_DYLIB(libEndpointSecuritySystem) to call ess_notify_su (the
# EndpointSecurity su-event telemetry hook).  Apple's private SoftLinking
# framework header is absent from every available tree; finishing su means
# sourcing or reconstructing that macro header.  The wiring below is
# correct and takes effect once <SoftLinking/SoftLinking.h> is provided.
T_LDADD+=	-lpam -lbsm
.include "${TOP}/mk/with-libutil.mk"
