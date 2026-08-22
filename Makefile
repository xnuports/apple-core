# Darwin Command Line Tools -- top-level Makefile (BSD bmake).
#
#	./build.sh?  No.  Just:  bmake
#
# Targets:
#	all		build every library and program into build/
#	clean		remove build/ entirely
#	list-progs	print the tool inventory with release placements
#
# The release tree lands in build/release/{bin,sbin,usr/{bin,sbin},
# usr/libexec}, mirroring where stock macOS keeps each tool.

TOP?=		${.CURDIR}

.include "${TOP}/mk/darwintools.sys.mk"

RELEASE=	${TOP}/build/release

all: dirs lib progs
	@${ECHO} "== darwintools build complete =="
	@${ECHO} "   release tree: ${RELEASE}"

dirs:
.for d in bin sbin usr/bin usr/sbin usr/libexec lib obj
	mkdir -p ${RELEASE}/${d}
.endfor

lib:
	${MAKE} -C ${TOP}/lib TOP=${TOP}

progs:
	${MAKE} -C ${TOP}/src TOP=${TOP}

list-progs:
	${MAKE} -C ${TOP}/src TOP=${TOP} list-progs

clean:
	rm -rf ${TOP}/build

.PHONY: all dirs lib progs list-progs clean
