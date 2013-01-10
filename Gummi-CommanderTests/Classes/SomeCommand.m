//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GCCommand.h"
#import "SomeCommand.h"
#import "GIInjector.h"
#import "SomeEvent.h"
#import "FlagObject.h"


@implementation SomeCommand
inject(@"event");
@synthesize event = _event;

- (void)execute {
    self.event.object.flag = YES;
    self.event.string = [self.event.string stringByAppendingString:@"1"];
}

@end