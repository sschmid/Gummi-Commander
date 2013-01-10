//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GCCommandMap.h"


@protocol GCEventBus;
@class GIInjector;

@interface GCGICommandMap : NSObject <GCCommandMap>
@property(nonatomic, strong) id <GCEventBus> eventBus;
@property(nonatomic, strong) GIInjector *injector;
@end