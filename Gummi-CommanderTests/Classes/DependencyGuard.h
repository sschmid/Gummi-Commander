//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GCGuard.h"

@class SomeEvent;
@class GIInjector;

@interface DependencyGuard : NSObject <GCGuard>
@property(nonatomic, strong) SomeEvent *event;
@property(nonatomic, strong) GIInjector *injector;
@end