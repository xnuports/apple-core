/*
 * mk/compat/fskit_stub.c -- FSKit-less build of invoke_tool_from_fskit().
 *
 * diskdev_cmds' disklib/fskit_support.m provides invoke_tool_from_fskit()
 * for mount(8), fsck(8) and newfs(8).  It selects between a real FSKit
 * implementation and a do-nothing fallback with
 *
 *	#if __has_include(<FSKit/FSKit.h>)
 *
 * On macOS that test succeeds -- FSKit.framework is public -- but the
 * real branch then imports <FSKit/FSKit_private.h> and <LiveFS/LiveFS.h>,
 * which Apple does not ship in any SDK.  __has_include() cannot be
 * overridden from the command line, and the submodule sources are not
 * ours to patch, so this file supplies the same fallback Apple's own
 * #else branch does: report that FSKit is unavailable and let the caller
 * fall back to the traditional tool path.
 *
 * Tool fragments compile this instead of fskit_support.m.  Drop it once
 * the FSKit/LiveFS private headers are vendored and the real .m builds.
 */

#include <errno.h>

#include "fskit_support.h"

int
invoke_tool_from_fskit(fskit_command_t operation, int flags,
                       int argc, char * const *argv)
{
	(void)operation;
	(void)flags;
	(void)argc;
	(void)argv;
	return ENOTSUP;
}
