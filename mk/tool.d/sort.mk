# sort(1): xcconfig defines SORT_VERSION + thread support; NLS stays on
# because file.c references `catalog` unguarded.
T_CFLAGS+=	-D'SORT_VERSION="2.3-Apple"' -DSORT_THREADS
