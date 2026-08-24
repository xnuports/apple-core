/*
 * xo_config.h - minimal hand-maintained configuration for building
 * libxo on Darwin outside autotools.  Mirrors what configure would
 * detect on macOS; keep in sync with lib/libxo/configure.ac.
 */
#ifndef XO_CONFIG_H
#define XO_CONFIG_H

/* libxo package version (configure.ac AC_INIT) */
#define LIBXO_VERSION "2.0.0"
#define LIBXO_VERSION_EXTRA ""

/* install paths (unused at runtime on Darwin; maps/filters load
 * from the current directory or LIBXO_PATH when enabled) */
#define XO_MAPDIR "/usr/share/libxo/map"
#define XO_FILTERDIR "/usr/share/libxo/filter"
#define XO_ENCODERDIR "/usr/share/libxo/encoder"

/* functions present in the Darwin C library */
#define HAVE_ASPRINTF 1
#define HAVE_BZERO 1
#define HAVE_CTIME 1
#define HAVE_FDOPEN 1
#define HAVE_FLOCK 1
#define HAVE_GETPASS 1
#define HAVE_GETPROGNAME 1
#define HAVE_GETRUSAGE 1
#define HAVE_GETTIMEOFDAY 1
#define HAVE_MEMMOVE 1
#define HAVE_SRAND 1
#define HAVE_STRCHR 1
#define HAVE_STRCSPN 1
#define HAVE_STRERROR 1
#define HAVE_STRLCPY 1
#define HAVE_STRSPN 1
#define HAVE_SYSCTLBYNAME 1
#define HAVE_DLFCN_H 1
#define HAVE_DLOPEN 1
#define HAVE_DLCLOSE 1
#define HAVE_DLSYM 1

/* headers */
#define HAVE_STDINT_H 1
#define HAVE_STDLIB_H 1
#define HAVE_STRING_H 1
#define HAVE_UNISTD_H 1
#define HAVE_SYS_PARAM_H 1
#define HAVE_LANGINFO_H 1

/* absent on Darwin: __flbf, dlfunc, memrchr, strchrnul, sranddev,
 * uexterr_gettext, stdio_ext.h, sys/exterrvar.h */

#endif /* XO_CONFIG_H */
