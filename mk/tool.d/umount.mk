# umount: checkvfsname()/vfslist.h live in diskdev_cmds/disklib;
# getmntopts()/mntopts.h come from our libutil.
#
# BLOCKED: disklib/vfslist.c pulls in <os/errno.h>, a private xnu header
# absent from the macOS SDK -- needs staging under include/os/ before
# this builds.
T_SRCS=		umount.c src/diskdev_cmds/disklib/vfslist.c
T_CFLAGS+=	-I${TOP}/src/diskdev_cmds/disklib
.include "${TOP}/mk/with-libutil.mk"
