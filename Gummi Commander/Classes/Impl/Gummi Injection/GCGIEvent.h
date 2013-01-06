//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "GCEvent.h"


@interface GCGIEvent : NSObject <GCEvent>
+ (void)dispatch;
@end