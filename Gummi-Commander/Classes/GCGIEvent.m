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
    [getObject([GDDispatcher class]) dispatchObject:self];
}

@end