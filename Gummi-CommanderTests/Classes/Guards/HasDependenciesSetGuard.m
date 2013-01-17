//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "HasDependenciesSetGuard.h"
#import "GIInjector.h"
#import "FlagAndStringEvent.h"

@implementation HasDependenciesSetGuard
inject(@"event", @"injector")

- (BOOL)approve {
    return self.event != nil && self.injector != nil;
}

@end