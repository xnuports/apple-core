# textutil(1): ObjC, AppKit + WebKit (macOS branch of its Makefile).
T_CFLAGS+=	-fobjc-arc
T_LDADD+=	-framework Foundation -framework CoreFoundation -lobjc \
		-framework AppKit -framework WebKit
