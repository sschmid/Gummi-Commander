//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "ServerResponseGreater500Guard.h"
#import "GIInjector.h"


@implementation ServerResponseGreater500Guard
inject(@"event")
@synthesize event = _event;

- (BOOL)approve {
    return [self.event.response intValue] > 500;
}

@end