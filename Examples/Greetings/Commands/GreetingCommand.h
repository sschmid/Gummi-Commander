//
// Created by sschmid on 27.11.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "SDCommand.h"

@class GreetingEvent;

@interface GreetingCommand : NSObject <SDCommand>
@property(nonatomic) GreetingEvent *event;
@end