//
// Created by sschmid on 02.12.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "SDGuard.h"

@class SomeEvent;
@class JSObjectionInjector;


@interface DependencyGuard : NSObject <SDGuard>
@property(nonatomic, strong) SomeEvent *event;
@property(nonatomic, strong) JSObjectionInjector *injector;
@end