/*
 * DiskImages2/DICommon.h -- minimal interface header for the DiskImages2
 * private framework.
 *
 * darwintools note: Apple ships no DiskImages2 headers in any SDK.  This
 * declares only what hfs' mount_hfs.c references: the IOKit class name of a
 * disk-image device and the two IORegistry property keys it reads to detect
 * a sparse-backed image and recover its backing URL.
 *
 * These are macros expanding to string literals, not CFStringRef externs,
 * because mount_hfs.c uses two of them inside CFSTR(), which requires a
 * compile-time literal, and passes the third to IOObjectConformsTo(), which
 * takes a C string.
 *
 * Values were recovered from Apple's shipped
 * /System/Library/Filesystems/hfs.fs/Contents/Resources/mount_hfs -- the
 * literals CFSTR() embedded in the binary -- and cross-checked against the
 * class names in the DiskImages2 binary itself.  Extend this header as
 * further DiskImages2 entry points are needed; it is not a complete
 * description of the framework's API.
 */

#ifndef _DARWINTOOLS_DISKIMAGES2_DICOMMON_H
#define _DARWINTOOLS_DISKIMAGES2_DICOMMON_H

/*
 * mount_hfs.c uses CFBooleanRef/CFURLRef/kCFBooleanTrue without including
 * CoreFoundation itself, so the real header must pull it in.
 */
#include <CoreFoundation/CoreFoundation.h>

/* IOKit class of a DiskImages2-backed device. */
#define kDIDeviceClass		"AppleDiskImageDevice"

/* IORegistry property: CFBoolean, true when the image is sparse-backed. */
#define kDISparseBackendKey	"sparse-backend"

/* IORegistry property: CFString, the URL of the backing disk image. */
#define kDIImageURLKey		"DiskImageURL"

#endif /* _DARWINTOOLS_DISKIMAGES2_DICOMMON_H */
