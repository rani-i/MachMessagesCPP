#pragma once

#include <mach/mach.h>
#import <Foundation/Foundation.h>

#ifdef DEBUG
#define MACH_LOG(fmt, ...) NSLog((@"[%s] : %s : " fmt), __FUNCTION__, mach_error_string(ret), ##__VA_ARGS__)
#define DEBUG_LOG(fmt, ...) NSLog((@"[%s]" fmt),  __FUNCTION__, ##__VA_ARGS__)
#else
#define MACH_LOG(fmt, ...)
#define DEBUG_LOG(fmt, ...)
#endif
