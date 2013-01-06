//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "GCGIEvent.h"

@class SomeObject;

@interface SomeEvent : GCGIEvent
@property(nonatomic, strong) SomeObject *object;
@property(nonatomic, strong) NSString *string;
@end