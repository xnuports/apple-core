# pbcopy(1) -- and pbpaste, the same binary under a second name: pbcopy.m
# switches on argv[0]'s last path component.  The Makefile picks AppKit on
# macOS and UIKit on iOS; AppKit owns the pasteboard here.
T_CFLAGS+=	-fobjc-arc
T_LDADD+=	-framework Foundation -framework CoreFoundation -lobjc -framework AppKit
T_LINKS=	pbpaste
