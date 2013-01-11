//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "ServiceModule.h"
#import "Model.h"
#import "Service.h"
#import "ServerResponseEvent.h"
#import "ServerResponseCommand.h"
#import "ServerResponseGreater500Guard.h"
#import "GIInjector.h"


@implementation ServiceModule

- (void)configure:(GIInjector *)injector {
    [super configure:injector];

    // Map events to commands
    [[self mapCommand:[ServerResponseCommand class] toEvent:[ServerResponseEvent class]]
            withGuards:@[[ServerResponseGreater500Guard class]]];

    // Set injection rules
    [self mapSingleton:[Model class] to:[Model class]];
    [self mapEagerSingleton:[Service class] to:[Service class]];
}

- (void)unload {
    Service *service = [_injector getObject:[Service class]];
    [service close];

    [super unload];
}

- (void)dealloc {
    NSLog(@"ServiceModule dealloc");
}

@end