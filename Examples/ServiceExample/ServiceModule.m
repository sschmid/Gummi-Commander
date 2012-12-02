//
// Created by sschmid on 30.11.12.
//
// contact@sschmid.com
//


#import "ServiceModule.h"
#import "Model.h"
#import "Service.h"
#import "ServerResponseEvent.h"
#import "ServerResponseCommand.h"
#import "SDEventCommandMapping.h"
#import "ServerResponseGreater500Guard.h"


@implementation ServiceModule

- (void)configure {
    [super configure];

    // Map events to commands
    [[self mapEventClass:[ServerResponseEvent class] toCommandClass:[ServerResponseCommand class]]
            withGuards:[NSArray arrayWithObject:[ServerResponseGreater500Guard class]]];

    // Set objection rules
    [self registerSingleton:[Model class]];
    [self registerEagerSingleton:[Service class]];
}

- (void)unload {
    Service *service = [self.injector getObject:[Service class]];
    [service close];

    [super unload];
}

- (void)dealloc {
    NSLog(@"ServiceModule dealloc");
}

@end