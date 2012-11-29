//
// Created by sschmid on 26.11.12.
//
// contact@sschmid.com
//


#import "SomeCommand.h"
#import "Objection.h"
#import "SomeEvent.h"
#import "SomeObject.h"

@implementation SomeCommand
objection_requires(@"event");
@synthesize event = _event;

- (void)execute {
    self.event.object.flag = YES;
    self.event.string = [self.event.string stringByAppendingString:@"1"];
}

@end