//
// Created by sschmid on 20.11.12.
//
// contact@sschmid.com
//


#import "SDCommandMap.h"
#import "JSObjectionInjector.h"
#import "SDEventBus.h"


@interface SDObjectionCommandMap : NSObject <SDCommandMap>
@property(nonatomic) JSObjectionInjector *injector;
@property(nonatomic) id <SDEventBus> eventBus;

@end