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
OBJBASE=	${TOP}/build/lib

LIBUTIL_SRCS=	humanize_number.c pidfile.c trimdomain.c realhostname.c \
		realhostname_sa.c expand_number.c getmntopts.c flopen.c \
		fparseln.c \
		getcap.c login_cap.c login_class.c login_ok.c \
		login_times.c _secure_path.c

LIBUTIL_OBJS=
.for f in ${LIBUTIL_SRCS}
. if exists(${LIBUTIL_DIR}/${f})
LIBUTIL_OBJS+=	${OBJBASE}/libutil/${f:R}.o
. endif
.endfor

all: ${OBJBASE}/libutil.a

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

clean:
	rm -rf ${OBJBASE}

list-libs:
	@${ECHO} "build/lib/libutil.a <-" ${LIBUTIL_OBJS:C|^${OBJBASE}/libutil/||}
