/*
 * compat.h -- FreeBSD-ism shims for building indent on macOS.
 * indent uses nitems() from FreeBSD's <sys/param.h>.
 */
#ifndef DARWINTOOLS_INDENT_COMPAT_H
#define DARWINTOOLS_INDENT_COMPAT_H

#include <sys/param.h>

#ifndef nitems
#define nitems(x) (sizeof((x)) / sizeof((x)[0]))
#endif

#endif /* DARWINTOOLS_INDENT_COMPAT_H */
