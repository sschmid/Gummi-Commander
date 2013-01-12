//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "SomeOtherCommand.h"
#import "GIInjector.h"

@implementation SomeOtherCommand
inject(@"event")

- (void)execute {
    self.event.string = [self.event.string stringByAppendingString:@"2"];
}

@end