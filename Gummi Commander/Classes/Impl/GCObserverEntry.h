//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>

@protocol GCEvent;

@interface GCObserverEntry : NSObject
@property(nonatomic, strong) id observer;
@property(nonatomic) SEL selector;
@property(nonatomic) int priority;

- (id)initWithObserver:(id)observer selector:(SEL)selector priority:(int)priority;
- (void)execute:(id <GCEvent>)event;
@end