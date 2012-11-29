//
// Created by sschmid on 26.11.12.
//
// contact@sschmid.com
//


#import "SomeOtherCommand.h"
#import "Objection.h"


@implementation SomeOtherCommand
objection_requires(@"event")
@synthesize event = _event;


- (void)execute {
    self.event.string = [self.event.string stringByAppendingString:@"2"];
}

@end