# chpass: edits user records via OpenDirectory (open_directory.c) using our
# staged <OpenDirectory/OpenDirectoryPriv.h> shim.
T_LDADD+=	-framework OpenDirectory -framework CoreFoundation
