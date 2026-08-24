/*
 * net/if_netem_models_private.h -- netem scheduler model values.
 *
 * darwintools note: ifconfig(8) accepts three netem models -- nlc, iod and
 * fpd -- but no published header names the last two.  Apple's open-source
 * xnu, the macOS SDK's Kernel.framework copy of net/if_var_private.h, and
 * the xnu tree vendored here all stop at:
 *
 *	IF_NETEM_MODEL_NULL = 0,
 *	IF_NETEM_MODEL_NLC  = 1,
 *
 * The installed OS is ahead of all of them: its /sbin/ifconfig accepts iod
 * and fpd, so the running kernel knows those values.
 *
 * They are recovered from that binary rather than assumed.  Disassembling
 * the model dispatch in /sbin/ifconfig shows each strcmp arm loading an
 * immediate and storing it at offset 0 of the params struct, which is
 * ifnetem_model:
 *
 *	"nlc" -> mov w8, #0x1 -+
 *	"iod" -> mov w8, #0x2  |-> str w8, [x19]
 *	"fpd" -> mov w8, #0x3 -+
 *
 * The nlc arm yielding 1 matches the published header, which is what makes
 * the other two trustworthy rather than a guess at sequential numbering.
 *
 * Drop this file once a header defining them is published.
 */

#ifndef _DARWINTOOLS_NET_IF_NETEM_MODELS_PRIVATE_H
#define _DARWINTOOLS_NET_IF_NETEM_MODELS_PRIVATE_H

#ifndef IF_NETEM_MODEL_IOD
#define IF_NETEM_MODEL_IOD	2
#endif

#ifndef IF_NETEM_MODEL_FPD
#define IF_NETEM_MODEL_FPD	3
#endif

#endif /* _DARWINTOOLS_NET_IF_NETEM_MODELS_PRIVATE_H */
