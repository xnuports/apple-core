#ifndef LIBSYSMON_H
#define LIBSYSMON_H

#include <xpc/xpc.h>
#include <dispatch/dispatch.h>
#include <os/object.h>
#include <stdint.h>

__BEGIN_DECLS

extern const char *_SYSMON_XPC_SERVICE_NAME;
extern const char *_SYSMON_XPC_KEY_TYPE;
extern const char *_SYSMON_XPC_KEY_ATTRIBUTES;
extern const char *_SYSMON_XPC_KEY_FLAGS;
extern const char *_SYSMON_XPC_REPLY_KEY_HEADER;
extern const char *_SYSMON_XPC_REPLY_KEY_TABLE;
extern const char *_SYSMON_XPC_REPLY_KEY_TIMESTAMP;

void *_sysmon_retain(void *obj);
void _sysmon_release(void *obj);

void *_sysmon_request_create(void (^handler)(void *table, void *error));
void *_sysmon_request_create_with_error(void **error, void (^handler)(void *table, void *error));
void *_sysmon_request_alloc(void *cls);
void _sysmon_request_execute(void *request);
void _sysmon_request_cancel(void *request);
void _sysmon_request_add_attribute(void *request, uint32_t attr);
void _sysmon_request_add_attributes(void *request, const uint32_t *attrs);
void _sysmon_request_set_flags(void *request, uint64_t flags);
void _sysmon_request_set_interval(void *request, uint64_t interval_ms);

uint64_t _sysmon_table_get_count(void *table);
void *_sysmon_table_get_row(void *table, uint64_t index);
void *_sysmon_table_copy_row(void *table, uint64_t index);
uint64_t _sysmon_table_get_timestamp(void *table);
void _sysmon_table_apply(void *table, void (^block)(void *row));

void *_sysmon_row_alloc(void *cls);
void _sysmon_row_apply(void *row, void (^block)(uint64_t attr_index, void *value));
void _sysmon_row_get_value(void *row, uint64_t attr_index, void **out_value);

void __sysmon_build_reply_with_diff(void *reply_dict, void *prev_table, uint64_t diff_type);

__END_DECLS

#endif /* LIBSYSMON_H */
