/*
 * compat.h -- shims for building bsdutils' timeout(1) on macOS.
 *
 * timeout.c calls signum_to_signame() to map a signal number to its name,
 * both when parsing -s/--signal and when reporting in verbose mode.  bsdutils
 * supplies it for Linux, which has no sys_signame[]; macOS declares
 * sys_signame[NSIG] in <signal.h>, so the shim is a straight lookup.
 *
 * Callers only ever pass 1 <= signo < NSIG (see the loops in timeout.c), but
 * the bound is checked anyway rather than trusting that from a header.
 */
#ifndef DARWINTOOLS_TIMEOUT_COMPAT_H
#define DARWINTOOLS_TIMEOUT_COMPAT_H

#include <signal.h>

static inline const char *
signum_to_signame(int signo)
{
	if (signo <= 0 || signo >= NSIG)
		return ("UNKNOWN");
	return (sys_signame[signo]);
}

#endif /* DARWINTOOLS_TIMEOUT_COMPAT_H */
