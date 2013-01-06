//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GCEvent.h"

@protocol GCEventBus <NSObject>

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName priority:(int)priority;

- (void)removeObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName;
- (void)removeObserver:(id)observer name:(NSString *)aName;
- (void)removeObserver:(id)observer;
- (void)removeAllObservers;

- (void)postEvent:(id <GCEvent>)event;

- (BOOL)hasObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName;
- (BOOL)hasObserver:(id)observer name:(NSString *)aName;
- (BOOL)hasObserver:(id)observer;

@end