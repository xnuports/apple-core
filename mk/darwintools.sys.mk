# mk/darwintools.sys.mk
#
# Global build knobs shared by every driver Makefile in this tree.
# Everything is built with BSD bmake(1); no GNU make idioms are used.
#
# Layout:
#
#	build/			generated; safe to delete at any time
#	build/lib		static libraries built from lib/ submodules
#	build/obj/<dir>		per-tool object files
#	build/release/		final staged tree:
#		bin/ sbin/ usr/bin/ usr/sbin/ usr/libexec/
#
# The release layout mirrors stock macOS placement (see mk/progs.mk).

TOP?=		${.CURDIR}

CC?=		cc
CPPFLAGS+=	-I${TOP}/include -I${TOP}/build/include
CFLAGS?=	-O2 -g -Wall -Wno-unused-parameter

AR?=		ar
YACC?=		yacc
LEX?=		lex

INSTALL_DIR=	mkdir -p

ECHO=		echo

.PHONY: all clean
