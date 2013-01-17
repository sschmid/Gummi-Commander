//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GCCommand.h"

@class FlagAndStringEvent;

@interface SetFlagCommand : NSObject <GCCommand>
@property(nonatomic, strong) FlagAndStringEvent *event;
@property(nonatomic, strong) NSNumber *executionTime;
@end