//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GreetingCommand.h"
#import "GreetingEvent.h"
#import "GIInjector.h"

@implementation GreetingCommand
inject(@"event")

- (void)execute {
    NSLog(@"%@", self.event.greeting);
}

@end