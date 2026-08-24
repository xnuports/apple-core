/*
 * SoftLinking/SoftLinking.h -- minimal soft-linking macros.
 *
 * darwintools note: Apple's <SoftLinking/SoftLinking.h> is not in any public
 * SDK (the internal SDK ships only the sibling WeakLinking.h).  These macros
 * are reconstructed from their use in shell_cmds/su/su.c, which is the only
 * consumer in this tree:
 *
 *	SOFT_LINK_DYLIB(libEndpointSecuritySystem)
 *	SOFT_LINK_FUNCTION(libEndpointSecuritySystem, ess_notify_su,
 *	                   soft_ess_notify_su, void, (params), (args))
 *	...
 *	if (islibEndpointSecuritySystemess_notify_suAvailable())
 *		soft_ess_notify_su(...);
 *
 * so SOFT_LINK_FUNCTION must define both a local wrapper under the given
 * alias and an is<dylib><symbol>Available() predicate.
 *
 * The implementation is the obvious one: dlopen(3) the dylib lazily,
 * dlsym(3) the symbol on first use, cache both, and report availability by
 * whether the lookup succeeded.  RTLD_LAZY|RTLD_LOCAL keeps the handle out
 * of the global namespace; the handle is intentionally never dlclose()d,
 * matching how soft-linked dylibs are used for the process lifetime.
 *
 * This reproduces the *behaviour* Apple's macros provide, not their exact
 * expansion: no availability checking beyond the symbol lookup, no
 * framework/bundle variants, no optional-dylib diagnostics.  It covers what
 * su needs and nothing more -- extend it if another tool starts soft-linking.
 */

#ifndef _DARWINTOOLS_SOFTLINKING_H
#define _DARWINTOOLS_SOFTLINKING_H

#include <dlfcn.h>
#include <stdbool.h>
#include <stddef.h>

/*
 * Declare a lazily-dlopen()ed dylib.  The path follows Apple's convention
 * for OS dylibs; the handle is resolved once, on first use.
 */
#define SOFT_LINK_DYLIB(dylib)						\
	static void *dylib##Library(void);				\
	static void *							\
	dylib##Library(void)						\
	{								\
		static void *handle;					\
		static bool tried;					\
		if (!tried) {						\
			tried = true;					\
			handle = dlopen("/usr/lib/" #dylib ".dylib",	\
			    RTLD_LAZY | RTLD_LOCAL);			\
		}							\
		return (handle);					\
	}

/*
 * Declare a soft-linked function.  Generates:
 *
 *	is<dylib><fn>Available()  -- true when the symbol resolved
 *	<alias>(args)             -- calls through to it
 *
 * Calling <alias> when the symbol is unavailable is a programming error;
 * callers are expected to gate on the predicate, as su does.
 */
#define SOFT_LINK_FUNCTION(dylib, fn, alias, rettype, params, args)	\
	static rettype (*soft_##dylib##_##fn) params;			\
	static bool							\
	is##dylib##fn##Available(void)					\
	{								\
		static bool tried;					\
		if (!tried) {						\
			void *h = dylib##Library();			\
			tried = true;					\
			if (h != NULL)					\
				soft_##dylib##_##fn = (rettype (*) params)\
				    dlsym(h, #fn);			\
		}							\
		return (soft_##dylib##_##fn != NULL);			\
	}								\
	static inline rettype						\
	alias params							\
	{								\
		return soft_##dylib##_##fn args;			\
	}

#endif /* _DARWINTOOLS_SOFTLINKING_H */
