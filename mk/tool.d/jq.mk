# jq -- JSON processor, with bundled decNumber and oniguruma (regex).
#
# No autoconf run here: the checked-in src/config_apple.h is force-included
# (jq sources never #include "config.h" themselves), and the generated
# lexer.c/parser.c/builtin.inc are already in the tree.  oniguruma is built
# from source in-place (--with-oniguruma=builtin) rather than as a lib.

JQ=		src/text_cmds/jq

# libjq + generated scanner/parser + the jq CLI entry point.
_JQ_SRC=	builtin bytecode compile execute jq_test jv jv_alloc jv_aux \
		jv_dtoa jv_file jv_parse jv_print jv_unicode linker locfile \
		util jv_dtoa_tsd lexer parser main

# oniguruma core (exactly libonig_la_SOURCES; posix_sources expanded).
# NOT a glob: modules/.../src also holds mktable.c (its own main) and
# unicode_*_data.c (#included, not compiled).
_ONIG_SRC=	regparse regcomp regexec regenc regerror regext regsyntax \
		regtrav regversion st reggnu regposix regposerr \
		unicode unicode_unfold_key unicode_fold1_key unicode_fold2_key \
		unicode_fold3_key ascii utf8 utf16_be utf16_le utf32_be utf32_le \
		euc_jp euc_jp_prop sjis sjis_prop iso8859_1 iso8859_2 iso8859_3 \
		iso8859_4 iso8859_5 iso8859_6 iso8859_7 iso8859_8 iso8859_9 \
		iso8859_10 iso8859_11 iso8859_13 iso8859_14 iso8859_15 \
		iso8859_16 euc_tw euc_kr big5 gb18030 koi8_r cp1251 onig_init

T_SRCS=
.for s in ${_JQ_SRC}
T_SRCS+=	${JQ}/src/${s}.c
.endfor
T_SRCS+=	${JQ}/src/decNumber/decContext.c ${JQ}/src/decNumber/decNumber.c
.for s in ${_ONIG_SRC}
T_SRCS+=	${JQ}/modules/oniguruma/src/${s}.c
.endfor

# -I at the jq root resolves builtin.c's #include "src/builtin.inc";
# _REENTRANT exposes the thread-safe lgamma_r et al. in <math.h>.
T_CFLAGS+=	-I${TOP}/${JQ} -I${TOP}/${JQ}/src \
		-I${TOP}/${JQ}/modules/oniguruma/src \
		-include ${TOP}/${JQ}/src/config_apple.h \
		-D_REENTRANT \
		-Wno-unused-parameter -Wno-unused-function
