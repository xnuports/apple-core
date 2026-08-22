#ifndef LIBSYSMON_INTERNAL_H
#define LIBSYSMON_INTERNAL_H

#include <dispatch/dispatch.h>
#include <xpc/xpc.h>
#include <os/object.h>

/* Internal structure definitions matching the binary layout.
 * These are cast from 'self' in ObjC methods. The first word is the isa
 * pointer, managed by the Objective-C runtime. */
struct _sysmon_request {
	/* isa pointer (managed by ObjC runtime, at offset 0) */
	dispatch_queue_t queue;
	void (^handler)(void *table, void *error);
	void (^error_handler)(void *table, void *error);
	xpc_connection_t connection;
	xpc_object_t request_msg;
	xpc_object_t prev_table;
	uint8_t done;
	uint8_t handler_invoked;
	uint32_t type;
	uint64_t flags;
	uint64_t interval_ms;
	uint32_t attr_count;
	uint8_t *attributes;
	size_t attrslen;
	uint8_t diff_type;
	uint8_t _pad[7];
};

struct _sysmon_table {
	/* isa pointer (managed by ObjC runtime, at offset 0) */
	xpc_object_t timestamp;
	xpc_object_t table_data;
	uint64_t row_count;
	struct _sysmon_row **rows;
};

struct _sysmon_row {
	/* isa pointer (managed by ObjC runtime, at offset 0) */
	xpc_object_t row_dict;
	xpc_object_t attr_bitmask;
};

#endif /* LIBSYSMON_INTERNAL_H */
