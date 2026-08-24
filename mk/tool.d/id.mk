# id(1) OpenDirectory support.
# kODTypeAuthenticationSearchNode exists only in the internal SDK; it denotes
# the authentication search node, i.e. the public kODNodeTypeAuthentication.
T_CFLAGS+=	-D'kODTypeAuthenticationSearchNode=kODNodeTypeAuthentication'
# open_directory.c uses DS constants without including their header; inject it.
T_CFLAGS+=	-include DirectoryService/DirServicesConst.h
# OD lookups use the OpenDirectory + CoreFoundation frameworks.
T_LDADD+=	-framework OpenDirectory -framework CoreFoundation -framework DirectoryService
