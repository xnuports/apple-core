# fsck_hfs: the checker proper lives in lib_fsck_hfs (dfalib); this is the
# driver.  See mk/with-libfsck_hfs.mk for the dfalib build flags.
#
# fsck_messages.c reports progress through FSKit's C hooks when running on an
# internal build; those come from our staged
# include/FSKit/FSKitCFunctions_private.h and resolve against the SDK's
# public FSKit.framework.
#
# dfalib's SControl.c reads a version banner that Apple's build produces with
# vers_string(1) and that no source in the tree defines.  Generate it here in
# Apple's format -- the shipped /System/Library/Filesystems/hfs.fs/Contents/
# Resources/fsck_hfs contains "@(#)PROGRAM:fsck_hfs  PROJECT:hfs-715.120.4",
# and SControl.c strstr()s for "PROJECT:" to pull the version out.

FSCKHFS_GEN=	${TOP}/build/gen/fsck_hfs
HFS_VERSION?=	hfs-715.120.4

T_SRCS=		fsck_hfs.c fsck_messages.c utilities.c \
		build/gen/fsck_hfs/fsck_hfs_vers.c

.include "${TOP}/mk/with-libfsck_hfs.mk"
T_LDADD+=	-framework CoreFoundation -framework IOKit -framework FSKit

${FSCKHFS_GEN}/fsck_hfs_vers.c:
	@mkdir -p ${FSCKHFS_GEN}
	@${ECHO} 'const unsigned char fsck_hfsVersionString[] =' > ${.TARGET}
	@${ECHO} '    "@(#)PROGRAM:fsck_hfs  PROJECT:${HFS_VERSION}\\n";' >> ${.TARGET}

.for s in ${T_SRCS}
${T_OBJDIR}/${s:T:R}.o: ${FSCKHFS_GEN}/fsck_hfs_vers.c
.endfor
