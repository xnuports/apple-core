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
CXX?=		c++
CXXFLAGS?=	${CFLAGS}

AR?=		ar
YACC?=		yacc
LEX?=		lex

INSTALL_DIR=	mkdir -p

ECHO=		echo

#
# Optional program tiers (Option C -- see SUBMODULE_AUDIT.md, PROGRESS.md).
# Both default OFF; the strict coreutils-like set ships by default.
# Enable with e.g.:
#
#	bmake MK_DIAGNOSTICS=yes MK_DAEMONS=yes MK_PRIVATE_FRAMEWORKS=yes
#
MK_DIAGNOSTICS?=	no
MK_DAEMONS?=		no
MK_PRIVATE_FRAMEWORKS?=	no

# System diagnostics / developer tools -- ship with macOS but are not
# part of the strict coreutils-like default set (SUBMODULE_AUDIT.md §2).
DIAG_PROGS=	fs_usage latency sc_usage ltop lsmp lskq hostinfo zprint \
		zlog mslutil kpgo mean stackshot gcore memory_pressure \
		vm_stat vm_purgeable_stat purge iostat iosim cpuctl \
		proc_uuid_policy dynamic_pager

# Network / service daemons -- not CLI userland; excluded by default.
DAEMON_PROGS=	telnetd tftpd talkd rtadvd rarpd spray kdumpd getty atrun

# Tools that link Apple private frameworks absent from the public SDK:
# FSKit (fsck_fskit, newfs_fskit, fstyp), APFS (mount), the quota disk
# library (quotacheck), and the kextmanager MIG interface (reboot,
# shutdown).  Off by default until those frameworks are available.
FRAMEWORK_PROGS=	fsck_fskit newfs_fskit fstyp mount quotacheck \
			reboot shutdown

# Names filtered out of the build loop when their tier is disabled.
DISABLED_PROGS=
.if ${MK_DIAGNOSTICS:tl} != "yes"
DISABLED_PROGS+=	${DIAG_PROGS}
.endif
.if ${MK_DAEMONS:tl} != "yes"
DISABLED_PROGS+=	${DAEMON_PROGS}
.endif
.if ${MK_PRIVATE_FRAMEWORKS:tl} != "yes"
DISABLED_PROGS+=	${FRAMEWORK_PROGS}
.endif

.PHONY: all clean
