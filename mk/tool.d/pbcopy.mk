# pbcopy(1): ObjC.  The Makefile picks AppKit on macOS and UIKit on iOS.
# Stock ships pbpaste too, but as a separate binary with no source here.
T_CFLAGS+=	-fobjc-arc
T_LDADD+=	-framework Foundation -framework CoreFoundation -lobjc -framework AppKit
