//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GummiCommander.h"
#import "GIInjector.h"
#import "GCDefaultEventBus.h"


@implementation GummiCommander

- (void)configure:(GIInjector *)injector {
    [super configure:injector];

    [self map:_injector to:[GIInjector class] ];
    [self mapSingleton:[GCDefaultEventBus class] to:@protocol(GCEventBus) lazy:YES];
    [self map:[GCGICommandMap class] to:@protocol(GCCommandMap)];

    NSLog(@"Gummi Commander initialized.");
}


@end