//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GCGuard.h"

@class FlagAndStringEvent;
@class GIInjector;

@interface HasDependenciesSetGuard : NSObject <GCGuard>
@property(nonatomic, strong) FlagAndStringEvent *event;
@property(nonatomic, strong) GIInjector *injector;
@end