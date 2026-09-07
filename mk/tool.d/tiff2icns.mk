# tiff2icns(1): ObjC, flags from AKCmds/tiff2icns/Makefile.
T_CFLAGS+=	-fobjc-arc
T_LDADD+=	-framework Foundation -framework CoreFoundation -lobjc \
		-framework AppKit -framework CoreGraphics
