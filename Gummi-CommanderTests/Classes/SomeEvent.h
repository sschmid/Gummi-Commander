//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GCGIEvent.h"

@class FlagObject;

@interface SomeEvent : GCGIEvent
@property(nonatomic, strong) FlagObject *object;
@property(nonatomic, strong) NSString *string;
@end