# at(1) build settings, mirroring the Apple xcodeproj:
# daemon uid/gid, queue defaults and the spool directory.
T_CFLAGS+=	-DDAEMON_UID=1
T_CFLAGS+=	-DDAEMON_GID=1
T_CFLAGS+=	-DDEFAULT_AT_QUEUE="'a'"
T_CFLAGS+=	-DDEFAULT_BATCH_QUEUE="'b'"
T_CFLAGS+=	-DPERM_PATH='"/usr/lib/cron/"'
