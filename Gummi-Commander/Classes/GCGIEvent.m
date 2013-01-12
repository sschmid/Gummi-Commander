//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GCGIEvent.h"
#import "GIInjector.h"
#import "GDDispatcher.h"

@implementation GCGIEvent

- (void)dispatch {
    GDDispatcher *dispatcher = [[GIInjector sharedInjector] getObject:[GDDispatcher class]];
    [dispatcher dispatchObject:self];
}

@end