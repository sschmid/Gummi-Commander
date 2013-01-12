//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "DependencyGuard.h"
#import "GIInjector.h"
#import "SomeEvent.h"

@implementation DependencyGuard
inject(@"event", @"injector")

- (BOOL)approve {
    return self.event != nil && self.injector != nil;
}

@end