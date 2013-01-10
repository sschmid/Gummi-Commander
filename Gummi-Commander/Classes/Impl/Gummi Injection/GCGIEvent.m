//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GCGIEvent.h"
#import "GCEventBus.h"
#import "GIInjector.h"


@implementation GCGIEvent

+ (void)dispatch {
    [[[self alloc] init] dispatch];
}

- (void)dispatch {
    id <GCEventBus> eventBus = [[GIInjector sharedInjector] getObject:@protocol(GCEventBus)];
    [eventBus postEvent:self];
}

@end