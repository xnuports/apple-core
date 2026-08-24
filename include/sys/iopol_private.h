/*
 * sys/iopol_private.h -- private I/O policy and process-role constants.
 *
 * darwintools note: these live in xnu's <sys/resource_private.h>, which the
 * public <sys/resource.h> only points at in a comment without including.
 * That header cannot be staged whole: before it reaches these defines it
 * includes <AvailabilityInternalPrivate.h>, which Apple ships in no SDK, for
 * a  #ifndef KERNEL  block of thread-counter declarations nothing here uses.
 *
 * So this is a verbatim extract of the private I/O-policy defines from
 * xnu bsd/sys/resource_private.h -- values unchanged, nothing invented.
 * taskpolicy needs the HFS case-sensitivity trio and PRIO_DARWIN_ROLE_UI;
 * the rest of each set is kept for context and for whatever needs it next.
 */

#ifndef _DARWINTOOLS_SYS_IOPOL_PRIVATE_H
#define _DARWINTOOLS_SYS_IOPOL_PRIVATE_H

#include <sys/resource.h>

/* Private setpriority()/getpriority() "what" and role values */
#define PRIO_DARWIN_ROLE		6	/* Second argument is a PID */

#define PRIO_DARWIN_ROLE_DEFAULT	0x0	/* Reset to default state */
#define PRIO_DARWIN_ROLE_UI_FOCAL	0x1	/* On  screen,     focal UI */
#define PRIO_DARWIN_ROLE_UI		0x2	/* On  screen UI,  focal unknown */
#define PRIO_DARWIN_ROLE_NON_UI		0x3	/* Off screen, non-focal UI */
#define PRIO_DARWIN_ROLE_UI_NON_FOCAL	0x4	/* On  screen, non-focal UI */
#define PRIO_DARWIN_ROLE_TAL_LAUNCH	0x5	/* Throttled-launch (OS X TAL resume) */
#define PRIO_DARWIN_ROLE_DARWIN_BG	0x6	/* Throttled, running in background */
#define PRIO_DARWIN_ROLE_USER_INIT	0x7	/* Off-screen, user-initiated work */

/* Private I/O type */
#define IOPOL_TYPE_VFS_HFS_CASE_SENSITIVITY	1
#define IOPOL_TYPE_VFS_ALTLINK			11
#define IOPOL_TYPE_VFS_NOCACHE_WRITE_FS_BLKSIZE	12
#define IOPOL_TYPE_VFS_SUPPORT_LONG_PATHS	13

#define IOPOL_VFS_HFS_CASE_SENSITIVITY_DEFAULT			0
#define IOPOL_VFS_HFS_CASE_SENSITIVITY_FORCE_CASE_SENSITIVE	1

#define IOPOL_VFS_ALTLINK_DISABLED	0
#define IOPOL_VFS_ALTLINK_ENABLED	1

#define IOPOL_VFS_SUPPORT_LONG_PATHS_DEFAULT	0
#define IOPOL_VFS_SUPPORT_LONG_PATHS_ON		1

#endif /* _DARWINTOOLS_SYS_IOPOL_PRIVATE_H */
