//
// Created by Simon Schmid
//
// contact@sschmid.com
//


@protocol GCEvent;

@protocol GCEventBus <NSObject>

- (void)addObserver:(id)observer forEvent:(Class)eventClass withSelector:(SEL)selector priority:(int)priority;

- (void)removeObserver:(id)observer fromEvent:(Class)eventClass withSelector:(SEL)selector;
- (void)removeObserver:(id)observer fromEvent:(Class)eventClass;
- (void)removeObserver:(id)observer;
- (void)removeAllObservers;

- (void)postEvent:(id <GCEvent>)event;

- (BOOL)hasObserver:(id)observer forEvent:(Class)eventClass withSelector:(SEL)selector;
- (BOOL)hasObserver:(id)observer forEvent:(Class)eventClass;
- (BOOL)hasObserver:(id)observer;

@end