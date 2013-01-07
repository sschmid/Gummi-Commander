//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GCCommandMap.h"

@class GIInjector;
@protocol GCEventBus;

@interface GCGICommandMap : NSObject <GCCommandMap>
@property(nonatomic, strong) GIInjector *injector;
@property(nonatomic, strong) id <GCEventBus> eventBus;
@end