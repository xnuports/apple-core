/*-
 * Public Domain dedication for darwintools.
 *
 * <CoreSymbolication/CoreSymbolication.h> shim: CoreSymbolication is a
 * private framework, but its binary ships with macOS and the entry
 * points used by zprint(8) are exported.  Declare just enough of the
 * API for tools to link and run against it.
 */

#ifndef _CORESYMBOLICATION_CORESYMBOLICATION_H_
#define _CORESYMBOLICATION_CORESYMBOLICATION_H_

#include <CoreFoundation/CoreFoundation.h>
#include <stdint.h>

__BEGIN_DECLS

typedef struct OpaqueCSSymbolicator *CSSymbolicatorRef;
typedef struct OpaqueCSSymbol       *CSSymbolRef;
typedef struct OpaqueCSSourceInfo   *CSSourceInfoRef;

/* The "now" time constant used by every *AtTime() call. */
#define kCSNow		(~(uint64_t)0)

CSSymbolicatorRef CSSymbolicatorCreateWithMachKernel(void);

CSSymbolRef CSSymbolicatorGetSymbolWithAddressAtTime(
	CSSymbolicatorRef	symbolicator,
	mach_vm_address_t	address,
	uint64_t		time);

CSSourceInfoRef CSSymbolicatorGetSourceInfoWithAddressAtTime(
	CSSymbolicatorRef	symbolicator,
	mach_vm_address_t	address,
	uint64_t		time);

const char *CSSymbolGetName(CSSymbolRef symbol);
const char *CSSourceInfoGetPath(CSSourceInfoRef sourceInfo);
size_t	CSSourceInfoGetLineNumber(CSSourceInfoRef sourceInfo);

__END_DECLS

#endif /* !_CORESYMBOLICATION_CORESYMBOLICATION_H_ */
