# ps: print.c uses the kpersona API from <System/sys/persona.h>, whose
# struct/declarations are gated behind PRIVATE (the private-header view).
T_CFLAGS+=	-DPRIVATE
