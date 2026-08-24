/*-
 * Public Domain dedication for darwintools.
 *
 * <IOKit/kext/OSKext.h> shim: the public SDK only ships KextManager.h,
 * but the IOKit framework also exports the OSKext* entry points that
 * zprint(8) uses.  Re-export the needed declarations.
 */

#ifndef _IOKIT_KEXT_OSKEXT_H_
#define _IOKIT_KEXT_OSKEXT_H_

#include <IOKit/kext/KextManager.h>

__BEGIN_DECLS

CFDictionaryRef OSKextCopyLoadedKextInfo(
	CFArrayRef		kextIdentifiers		/* can be NULL */,
	CFArrayRef		infoKeys		/* can be NULL */);

__END_DECLS

#endif /* !_IOKIT_KEXT_OSKEXT_H_ */
