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

clean:
	rm -rf ${OBJBASE}

libxo-clean: .PHONY
	rm -rf ${OBJBASE}/libxo ${OBJBASE}/libxo.a ${OBJBASE}/xo_config.h \
		${OBJBASE}/netcmds ${OBJBASE}/libnetcmds.a

list-libs: .PHONY
	@${ECHO} "build/lib/libutil.a <-" ${LIBUTIL_OBJS:C|^${OBJBASE}/libutil/||}
	@${ECHO} "build/lib/libxo.a   <-" ${LIBXO_OBJS:C|^${OBJBASE}/libxo/||}
	@${ECHO} "build/lib/libnetcmds.a <-" ${NETLIB_OBJS:C|^${OBJBASE}/netcmds/||}
