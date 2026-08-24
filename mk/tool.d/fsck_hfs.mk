# fsck_hfs: the checker proper lives in lib_fsck_hfs (dfalib); this is the
# driver.  See mk/with-libfsck_hfs.mk.
#
# BLOCKED: dfalib's SRuntime.h includes <Errors.h>, the classic Mac OS
# error-code header.  Apple no longer ships it: CarbonCore's MacErrors.h
# covers 11 of the 16 codes dfalib uses, and MacTypes.h supplies noErr,
# but fsBTInvalidNodeErr, vcInvalidExtentErr, hardwareGoneErr and
# fsEndOfIterationErr are in no public SDK, in the internal SDK, or in the
# hfs sources themselves -- Apple builds this against a full CarbonHeaders
# set we do not have.
#
# Their numeric values are deliberately NOT guessed: a wrong OSErr value in
# a filesystem checker misclassifies errors silently.  Supply a real
# Errors.h (or the four values from an authoritative source) and drop this
# note; the wiring below is otherwise complete and lib/Makefile already
# builds libfsck_hfs.a.
T_NOBUILD=	yes
.include "${TOP}/mk/with-libfsck_hfs.mk"
T_LDADD+=	-framework CoreFoundation -framework IOKit
