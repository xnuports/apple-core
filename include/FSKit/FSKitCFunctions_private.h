/*
 * FSKit/FSKitCFunctions_private.h -- the FSKit C progress hooks fsck uses.
 *
 * darwintools note: Apple ships FSKit.framework publicly but not this private
 * header, so fsck_hfs' fsck_messages.c cannot compile: it tests
 * __has_include(<FSKit/FSKit.h>), which succeeds, then includes this.
 *
 * Only three entry points are needed, and both their existence and their
 * signatures are established rather than guessed:
 *
 *   - FSKit exports them as plain C functions; `nm -gU` on the FSKit binary
 *     extracted from the dyld shared cache shows _FSKitCheckStart,
 *     _FSKitCheckUpdate and _FSKitCheckDone as text symbols.
 *   - The parameter types come from the call sites in fsck_messages.c:
 *     fsckStart(ctx, const char *device_name, const char *volume_name) passes
 *     both straight to FSKitCheckStart, and fsckUpdate/fsckDone pass their
 *     int argument to FSKitCheckUpdate/FSKitCheckDone.
 *
 * Return values are declared void: every call site ignores the result, so
 * this is safe regardless of what the real functions return.
 *
 * Note these hooks are inert on a normal system anyway -- fsck_messages.c
 * only calls them when os_variant_has_internal_content("com.apple.FSKit")
 * is true, i.e. on internal builds.
 *
 * FSKit also exports FSKitCheckContainerStart, which nothing here uses; add
 * it if a tool starts needing it.
 */

#ifndef _DARWINTOOLS_FSKIT_CFUNCTIONS_PRIVATE_H
#define _DARWINTOOLS_FSKIT_CFUNCTIONS_PRIVATE_H

#include <sys/cdefs.h>

__BEGIN_DECLS

/* Report the start of a check on the given device / volume. */
void	FSKitCheckStart(const char *device_name, const char *volume_name);

/* Report progress, 0-100. */
void	FSKitCheckUpdate(int percentage_complete);

/* Report completion; error is the fsck exit status. */
void	FSKitCheckDone(int error);

__END_DECLS

#endif /* _DARWINTOOLS_FSKIT_CFUNCTIONS_PRIVATE_H */
