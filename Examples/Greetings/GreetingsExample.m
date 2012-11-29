//
// Created by sschmid on 27.11.12.
//
// contact@sschmid.com
//


#import "GreetingsExample.h"
#import "Objection.h"
#import "GummiModule.h"
#import "GreetingsModule.h"
#import "GreetingEvent.h"


@implementation GreetingsExample

- (id)init {
    self = [super init];
    if (self) {

        // Init Gummi
        JSObjectionInjector *injector = [JSObjection createInjector];
        [JSObjection setDefaultInjector:injector];
        [injector addModule:[[GummiModule alloc] init]];

        // Plug in example
        [injector addModule:[[GreetingsModule alloc] init]];

        // Logs greeting
        [GreetingEvent greet:@"Hello World!"];

        // Does not greet anymore
        [injector removeModuleClass:[GreetingsModule class]];
        [GreetingEvent greet:@"No one hears me :("];

    }

    return self;
}


@end