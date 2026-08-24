# newfs_hfs: dowipefs() calls into wipefs(), Apple's addition to libutil
# (C++, hence libc++).  Volume-name handling uses CoreFoundation and it
# queries the IORegistry for device geometry.
.include "${TOP}/mk/with-libutil.mk"
T_LDADD+=	-lc++ -framework CoreFoundation -framework IOKit
