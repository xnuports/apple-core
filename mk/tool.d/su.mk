# su: PAM auth + BSM audit session; login_cap comes from our libutil.
# <rootless.h> is staged from the internal SDK (SIP restricted-env check),
# and <SoftLinking/SoftLinking.h> from include/ -- su soft-links
# libEndpointSecuritySystem to report su events via ess_notify_su().
T_LDADD+=	-lpam -lbsm
.include "${TOP}/mk/with-libutil.mk"
