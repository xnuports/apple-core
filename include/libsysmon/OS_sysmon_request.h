//
//  OS_sysmon_request.h
//  libsysmon
//
//  Reverse-engineered from macOS 26.5 dyld_shared_cache
//

#import <Foundation/Foundation.h>
#import "OS_sysmon_object.h"

@protocol OS_sysmon_request <OS_sysmon_object>
@required
@optional
@end

@interface OS_sysmon_request : OS_sysmon_object <OS_sysmon_request>
- (oneway void)release;
- (void)dealloc;
@end
