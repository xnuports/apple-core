# bc -- Gavin D. Howard's bc/dc (single binary, dc hardlinked to bc).
#
# Sources live in src/bc/bc/src; four more C files (the bc/dc math
# libraries and help text) are generated at build time by gen/strgen.sh.
# Config is entirely -D driven (no autoconf); history uses libedit.

BC_DIR=		${TOP}/src/bc/bc
BC_GEN=		${TOP}/build/gen/bc

# All CLI sources (everything under src/ except the two fuzzers) plus the
# four generated sources.  Paths are TOP-relative so tool.mk compiles them
# out-of-tree.
T_SRCS!=	cd ${TOP} && ls src/bc/bc/src/*.c | grep -vE 'fuzzer'
T_SRCS+=	build/gen/bc/lib.c build/gen/bc/lib2.c \
		build/gen/bc/bc_help.c build/gen/bc/dc_help.c

# Define set mirrors Apple's bc.xcodeproj; BUILD_TYPE=A selects the config
# profile that supplies defaults for the remaining BC_ENABLE_* knobs.
T_CFLAGS+=	-I${BC_DIR}/include \
		-DBUILD_TYPE=A -DMAINEXEC=bc -DNDEBUG \
		-DBC_ENABLED -DDC_ENABLED -DBC_ENABLE_HISTORY \
		-DBC_ENABLE_EXTRA_MATH -DBC_ENABLE_EDITLINE
T_LDADD+=	-ledit

# dc is the same binary, hardlinked (Apple ships it this way).
T_LINKS=	dc

# --- generated sources (gen/strgen.sh must run from BC_DIR) -----------
${BC_GEN}/lib.c:
	@mkdir -p ${BC_GEN}
	cd ${BC_DIR} && sh gen/strgen.sh gen/lib.bc ${BC_GEN}/lib.c 0 bc_lib bc_lib_name 1 1
${BC_GEN}/lib2.c:
	@mkdir -p ${BC_GEN}
	cd ${BC_DIR} && sh gen/strgen.sh gen/lib2.bc ${BC_GEN}/lib2.c 0 bc_lib2 bc_lib2_name 1 1
${BC_GEN}/bc_help.c:
	@mkdir -p ${BC_GEN}
	cd ${BC_DIR} && sh gen/strgen.sh gen/bc_help.txt ${BC_GEN}/bc_help.c 0 bc_help
${BC_GEN}/dc_help.c:
	@mkdir -p ${BC_GEN}
	cd ${BC_DIR} && sh gen/strgen.sh gen/dc_help.txt ${BC_GEN}/dc_help.c 0 dc_help
