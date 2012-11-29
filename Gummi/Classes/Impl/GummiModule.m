//
// Created by sschmid on 22.11.12.
//
// contact@sschmid.com
//


#import "GummiModule.h"
#import "SDDefaultEventBus.h"
#import "SDObjectionCommandMap.h"


@implementation GummiModule

- (void)configure:(JSObjectionInjector *)injector {
    [super configure:injector];

    [self bind:injector toClass:[JSObjectionInjector class]];
    [self bindClass:[SDDefaultEventBus class] toProtocol:@protocol(SDEventBus) asSingleton:YES];
    [self bindClass:[SDObjectionCommandMap class] toProtocol:@protocol(SDCommandMap) asSingleton:NO];
}


@end