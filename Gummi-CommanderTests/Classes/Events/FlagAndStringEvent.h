//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GCGIEvent.h"

@class FlagAndStringObject;

@interface FlagAndStringEvent : GCGIEvent
@property(nonatomic, strong) FlagAndStringObject *object;
@end