//
// Created by sschmid on 20.11.12.
//
// contact@sschmid.com
//


#import "SDCommandMap.h"

@class JSObjectionInjector;
@protocol SDEventBus;

@interface SDObjectionCommandMap : NSObject <SDCommandMap>

@property(nonatomic) JSObjectionInjector *injector;
@property(nonatomic) id <SDEventBus> eventBus;
@end