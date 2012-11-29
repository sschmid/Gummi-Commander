//
// Created by sschmid on 20.11.12.
//
// contact@sschmid.com
//


@protocol SDEvent;

@protocol SDEventBus <NSObject>

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName priority:(int)priority;

- (void)removeObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName;
- (void)removeObserver:(id)observer name:(NSString *)aName;
- (void)removeObserver:(id)observer;
- (void)removeAllObservers;

- (void)postEvent:(id <SDEvent>)event;

- (BOOL)hasObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName;
- (BOOL)hasObserver:(id)observer name:(NSString *)aName;
- (BOOL)hasObserver:(id)observer;

@end