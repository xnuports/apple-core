/*
 * sys/prctl.h -- Darwin shim for the two prctl(2) operations timeout(1) uses.
 *
 * darwintools note: the timeout(1) we vendored from bsdutils uses Linux's
 * child-subreaper API.  Darwin has no equivalent -- neither Linux's
 * prctl(PR_SET_CHILD_SUBREAPER) nor FreeBSD's procctl(PROC_REAP_ACQUIRE) --
 * and there is no way to have orphaned grandchildren reparent to us instead
 * of to launchd.
 *
 * timeout uses the facility only to decide how long to keep waiting: with a
 * subreaper it keeps waiting while any descendant survives the direct child;
 * without one it cannot see them at all.  This shim therefore reports "no
 * descendants remain", which is accurate on Darwin -- they have already been
 * reparented away from us -- and lets timeout exit once the command it
 * actually spawned is gone.
 *
 * BEHAVIOURAL DIFFERENCE, and it is a real one: with --foreground timeout
 * behaves exactly as on Linux/FreeBSD, but in the default (background) mode
 * it returns when the direct child exits rather than when the last
 * descendant does.  A command that backgrounds work of its own and exits can
 * therefore outlive its timeout.  Removing this shim requires a Darwin
 * process-reaping strategy, not a header.
 */

#ifndef _DARWINTOOLS_SYS_PRCTL_H
#define _DARWINTOOLS_SYS_PRCTL_H

#include <stdarg.h>
#include <stddef.h>

#define PR_SET_CHILD_SUBREAPER	36
#define PR_GET_CHILD_SUBREAPER	37

static inline int
prctl(int option, ...)
{
	va_list ap;
	unsigned long *out;

	switch (option) {
	case PR_SET_CHILD_SUBREAPER:
		/* No subreaper on Darwin; accept and ignore. */
		return (0);

	case PR_GET_CHILD_SUBREAPER:
		/* Report no surviving descendants (see note above). */
		va_start(ap, option);
		out = va_arg(ap, unsigned long *);
		va_end(ap);
		if (out != NULL)
			*out = 0;
		return (0);

	default:
		return (0);
	}
}

#endif /* _DARWINTOOLS_SYS_PRCTL_H */
