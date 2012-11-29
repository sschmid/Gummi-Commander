//
// Created by sschmid on 27.11.12.
//
// contact@sschmid.com
//


#import "GreetingCommand.h"
#import "Objection.h"
#import "GreetingEvent.h"


@implementation GreetingCommand
objection_requires(@"event")
@synthesize event = _event;

- (void)execute {
    NSLog(@"%@", self.event.greeting);
}

@end