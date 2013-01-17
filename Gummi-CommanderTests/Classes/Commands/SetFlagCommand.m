//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "SetFlagCommand.h"
#import "GIInjector.h"
#import "FlagAndStringEvent.h"
#import "FlagAndStringObject.h"

@implementation SetFlagCommand
inject(@"event")

- (void)execute {
    self.executionTime = @(CACurrentMediaTime());
    self.event.object.flag = YES;
}

@end