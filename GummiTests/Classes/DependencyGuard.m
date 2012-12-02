//
// Created by sschmid on 02.12.12.
//
// contact@sschmid.com
//


#import "DependencyGuard.h"
#import "SomeEvent.h"
#import "Objection.h"


@implementation DependencyGuard
objection_requires(@"event", @"injector")

@synthesize event = _event;
@synthesize injector = _injector;


- (BOOL)approve {
    return self.event != nil && self.injector != nil;
}

@end