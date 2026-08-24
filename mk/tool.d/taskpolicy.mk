# taskpolicy: uses three PRIVATE I/O-policy constants
# (IOPOL_TYPE_VFS_HFS_CASE_SENSITIVITY and its two values).  The public
# <sys/resource.h> only points at <sys/resource_private.h> in a comment
# without including it, and that header cannot be used as-is here, so
# force-include our extract of its I/O-policy defines.
T_CFLAGS+=	-include ${TOP}/include/sys/iopol_private.h
