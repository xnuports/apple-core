# open(1): ios_open.m is the iOS variant and uses LSApplicationProxy, which
# does not exist on macOS.  Its Makefile selects sources per platform; take
# the macOS set (and its ApplicationServices link) rather than letting source
# discovery pull in both.
T_SRCS=		open.m header_search.m utils.m
T_CFLAGS+=	-fblocks
T_LDADD+=	-framework Foundation -framework CoreFoundation -lobjc \
		-framework AppKit -framework ApplicationServices
