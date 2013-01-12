//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GummiCommanderModule.h"
#import "GIInjector.h"
#import "GDDispatcher.h"

@implementation GummiCommanderModule

- (void)configure:(GIInjector *)injector {
    [super configure:injector];

    [self map:_injector to:[GIInjector class] ];
    [self mapSingleton:[GDDispatcher class] to:[GDDispatcher class]];
    [self map:[GCGICommandMap class] to:@protocol(GCCommandMap)];

    NSLog(@"Gummi Commander initialized.");
}


@end