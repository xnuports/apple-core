# passwd: OpenDirectory-backed password change; PAM for the auth path.
# <OpenDirectory/OpenDirectoryPriv.h> is our staged shim over the public
# CFOpenDirectory headers.
T_LDADD+=	-framework OpenDirectory -framework CoreFoundation -lpam
