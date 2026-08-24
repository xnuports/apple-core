# dnctl: the userland dummynet API in <netinet/ip_dummynet.h> (our staged
# xnu header) is gated behind PRIVATE -- the private-header view dnctl needs.
T_CFLAGS+=	-DPRIVATE
