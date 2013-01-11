//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GCGIExtension.h"
#import "GreetingsModule.h"
#import "GreetingEvent.h"
#import "GreetingCommand.h"
#import "GIInjector.h"

@implementation GreetingsModule

- (void)configure:(GIInjector *)injector {
    [super configure:injector];

    [self mapCommand:[GreetingCommand class] toEvent:[GreetingEvent class]];
}

@end