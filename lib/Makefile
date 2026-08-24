# lib/Makefile
#
# Builds the static libraries consumed by the tools, from the
# submodules under lib/, into build/lib/.  Submodules are read-only;
# sources are referenced in place.
#
# NOTE: libutil's FreeBSD port (getcap/login_cap/login_class family)
# lands with the next submodule bump; the exists() filter below picks
# those files up automatically once present.

TOP?=		${.CURDIR}

.include "${TOP}/mk/darwintools.sys.mk"

LIBUTIL_DIR=	${TOP}/lib/libutil
LIBXO_DIR=	${TOP}/lib/libxo
LIBTELNET_DIR=	${TOP}/lib/libtelnet
LIBFSCKHFS_DIR=	${TOP}/src/hfs/lib_fsck_hfs

# dfalib's SRuntime.h still uses the classic Mac Memory Manager API
# (NewPtr/DisposeHandle/BlockMoveData); MacMemory.h lives inside the SDK's
# CarbonCore framework, which is not on the default include path.
SDKROOT_PATH!=	xcrun --show-sdk-path 2>/dev/null || echo /
CARBONCORE_HDRS=	${SDKROOT_PATH}/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/CarbonCore.framework/Versions/A/Headers
OBJBASE=	${TOP}/build/lib

LIBUTIL_SRCS=	humanize_number.c pidfile.c trimdomain.c realhostname.c \
		realhostname_sa.c expand_number.c getmntopts.c flopen.c \
		usbuf.c \
		fparseln.c \
		getcap.c login_cap.c login_class.c login_ok.c \
		login_times.c _secure_path.c

LIBUTIL_OBJS=
.for f in ${LIBUTIL_SRCS}
. if exists(${LIBUTIL_DIR}/${f})
LIBUTIL_OBJS+=	${OBJBASE}/libutil/${f:R}.o
. endif
.endfor

all: ${OBJBASE}/libutil.a ${OBJBASE}/libxo.a ${OBJBASE}/libnetcmds.a \
	${OBJBASE}/libtelnet.a

# --- libnetcmds ---------------------------------------------------
#
# Shared helpers for the network_cmds family (arp, netstat, ping,
# route, traceroute, ...).  Sources live inside the network_cmds
# checkout rather than a lib/ submodule, hence the longer path.

NETLIB_DIR=	${TOP}/src/network_cmds/network_cmds_lib

NETLIB_SRCS=	network_cmds_lib.c gmt2local.c

NETLIB_OBJS=
.for f in ${NETLIB_SRCS}
. if exists(${NETLIB_DIR}/${f})
NETLIB_OBJS+=	${OBJBASE}/netcmds/${f:R}.o
. endif
.endfor

.PATH: ${NETLIB_DIR}

.for f in ${NETLIB_SRCS}
. if exists(${NETLIB_DIR}/${f})
${OBJBASE}/netcmds/${f:R}.o: ${NETLIB_DIR}/${f}
	@mkdir -p ${OBJBASE}/netcmds
	${CC} ${CPPFLAGS} -I${NETLIB_DIR} \
		${CFLAGS} -c ${.ALLSRC} -o ${.TARGET}
. endif
.endfor

${OBJBASE}/libnetcmds.a: ${NETLIB_OBJS}
	rm -f ${.TARGET}
	${AR} crs ${.TARGET} ${NETLIB_OBJS}

# --- libutil ------------------------------------------------------

${OBJBASE} ${OBJBASE}/libutil:
	mkdir -p ${.TARGET}

.for f in ${LIBUTIL_SRCS}
. if exists(${LIBUTIL_DIR}/${f})
${OBJBASE}/libutil/${f:R}.o: ${LIBUTIL_DIR}/${f}
	@mkdir -p ${OBJBASE}/libutil
	${CC} ${CPPFLAGS} -I${LIBUTIL_DIR} -I${TOP}/include \
		${CFLAGS} -c ${.ALLSRC} -o ${.TARGET}
. endif
.endfor

# wipefs is Apple's addition to libutil and is C++, so it gets its own rule.
# newfs_hfs (and newfs_* generally) call wipefs_alloc()/wipefs_wipe().
.if exists(${LIBUTIL_DIR}/wipefs.cpp)
LIBUTIL_CXX_SRCS=	wipefs.cpp ExtentManager.cpp
.for f in ${LIBUTIL_CXX_SRCS}
. if exists(${LIBUTIL_DIR}/${f})
LIBUTIL_OBJS+=	${OBJBASE}/libutil/${f:R}.o

${OBJBASE}/libutil/${f:R}.o: ${LIBUTIL_DIR}/${f}
	@mkdir -p ${OBJBASE}/libutil
	${CXX} ${CPPFLAGS} -I${LIBUTIL_DIR} -I${TOP}/include \
		${CXXFLAGS} -c ${.ALLSRC} -o ${.TARGET}
. endif
.endfor
.endif

${OBJBASE}/libutil.a: ${LIBUTIL_OBJS}
	rm -f ${.TARGET}
	${AR} crs ${.TARGET} ${LIBUTIL_OBJS}

# --- libxo --------------------------------------------------------
#
# Built outside autotools; xo_config.h comes from our hand-maintained
# Darwin configuration (mk/xo_config.darwin.h) and is published into
# build/include/ so consumers find it via the default CPPFLAGS.

LIBXO_SRCS=	libxo.c xo_encoder.c xo_format.c xo_syslog.c \
		xo_tolower.c xo_toupper.c xo_utf8.c

LIBXO_OBJS=
.for f in ${LIBXO_SRCS}
. if exists(${LIBXO_DIR}/libxo/${f})
LIBXO_OBJS+=	${OBJBASE}/libxo/${f:R}.o
. endif
.endfor

${OBJBASE}/xo_config.h: ${TOP}/mk/xo_config.darwin.h
	cp ${.ALLSRC} ${.TARGET}

.PATH: ${LIBXO_DIR}/libxo

.for f in ${LIBXO_SRCS}
. if exists(${LIBXO_DIR}/libxo/${f})
${OBJBASE}/libxo/${f:R}.o: ${LIBXO_DIR}/libxo/${f} ${OBJBASE}/xo_config.h
	@mkdir -p ${OBJBASE}/libxo
	${CC} ${CPPFLAGS} -I${OBJBASE} -I${LIBXO_DIR}/libxo \
		${CFLAGS} -c ${.ALLSRC:M*.c} -o ${.TARGET}
. endif
.endfor

${OBJBASE}/libxo.a: ${LIBXO_OBJS}
	rm -f ${.TARGET}
	${AR} crs ${.TARGET} ${LIBXO_OBJS}

# --- libtelnet -----------------------------------------------------
#
# Only the crypto-free support pieces (option negotiation helpers).
# The auth/encrypt sources need krb5/DES and are pulled in solely under
# -DAUTHENTICATION/-DENCRYPTION, which the darwintools telnet does not set.

LIBTELNET_SRCS=	misc.c genget.c getent.c

LIBTELNET_OBJS=
.for f in ${LIBTELNET_SRCS}
. if exists(${LIBTELNET_DIR}/${f})
LIBTELNET_OBJS+=	${OBJBASE}/libtelnet/${f:R}.o
. endif
.endfor

.for f in ${LIBTELNET_SRCS}
. if exists(${LIBTELNET_DIR}/${f})
${OBJBASE}/libtelnet/${f:R}.o: ${LIBTELNET_DIR}/${f}
	@mkdir -p ${OBJBASE}/libtelnet
	${CC} ${CPPFLAGS} -I${LIBTELNET_DIR} \
		${CFLAGS} -c ${.ALLSRC} -o ${.TARGET}
. endif
.endfor

${OBJBASE}/libtelnet.a: ${LIBTELNET_OBJS}
	rm -f ${.TARGET}
	${AR} crs ${.TARGET} ${LIBTELNET_OBJS}

# --- libfsck_hfs ---------------------------------------------------
#
# NOT in `all`: dfalib needs the classic <Errors.h>, which Apple no longer
# ships, so this target cannot compile yet (see mk/tool.d/fsck_hfs.mk).
# Build it explicitly once that header is available:
#
#	bmake -C lib build/lib/libfsck_hfs.a
#
# fsck_hfs' support library, from the hfs submodule rather than lib/.
# Sources are discovered so the dfalib set tracks upstream; DecompMakeData
# is excluded -- it is a build-time generator with its own main(), not
# library code.

LIBFSCKHFS_SRCS!=	cd ${LIBFSCKHFS_DIR} && ls *.c dfalib/*.c 2>/dev/null | grep -v DecompMakeData || true

LIBFSCKHFS_OBJS=
.for f in ${LIBFSCKHFS_SRCS}
LIBFSCKHFS_OBJS+=	${OBJBASE}/fsck_hfs/${f:T:R}.o
.endfor

.for f in ${LIBFSCKHFS_SRCS}
${OBJBASE}/fsck_hfs/${f:T:R}.o: ${LIBFSCKHFS_DIR}/${f}
	@mkdir -p ${OBJBASE}/fsck_hfs
	${CC} ${CPPFLAGS} -I${LIBFSCKHFS_DIR} -I${LIBFSCKHFS_DIR}/dfalib \
		-I${TOP}/src/hfs/fsck_hfs -I${TOP}/include \
		-I${CARBONCORE_HDRS} \
		${CFLAGS} -c ${.ALLSRC} -o ${.TARGET}
.endfor

${OBJBASE}/libfsck_hfs.a: ${LIBFSCKHFS_OBJS}
	rm -f ${.TARGET}
	${AR} crs ${.TARGET} ${LIBFSCKHFS_OBJS}

clean:
	rm -rf ${OBJBASE}

libxo-clean: .PHONY
	rm -rf ${OBJBASE}/libxo ${OBJBASE}/libxo.a ${OBJBASE}/xo_config.h \
		${OBJBASE}/netcmds ${OBJBASE}/libnetcmds.a

list-libs: .PHONY
	@${ECHO} "build/lib/libutil.a <-" ${LIBUTIL_OBJS:C|^${OBJBASE}/libutil/||}
	@${ECHO} "build/lib/libxo.a   <-" ${LIBXO_OBJS:C|^${OBJBASE}/libxo/||}
	@${ECHO} "build/lib/libnetcmds.a <-" ${NETLIB_OBJS:C|^${OBJBASE}/netcmds/||}
