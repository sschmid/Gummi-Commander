//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "GCCommand.h"

@class GreetingEvent;

@interface GreetingCommand : NSObject <GCCommand>
@property(nonatomic) GreetingEvent *event;
@end