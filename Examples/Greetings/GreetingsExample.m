//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GreetingsExample.h"
#import "GIInjector.h"
#import "GummiCommander.h"
#import "GreetingsModule.h"
#import "GreetingEvent.h"


@implementation GreetingsExample

- (id)init {
    self = [super init];
    if (self) {

        // Init Gummi
        GIInjector *injector = [GIInjector sharedInjector];
        [injector addModule:[[GummiCommander alloc] init]];

        // Plug in example
        [injector addModule:[[GreetingsModule alloc] init]];

        // Logs greeting
        [GreetingEvent greet:@"Hello World!"];

        // Does not greet anymore
        [injector removeModuleClass:[GreetingsModule class]];
        [GreetingEvent greet:@"No one hears me :("];

        [[GIInjector sharedInjector] reset];
    }

    return self;
}

@end