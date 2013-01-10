//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GCDefaultEventBus.h"
#import "GCObserverEntry.h"
#import "GCEvent.h"

@interface GCDefaultEventBus ()
@property(nonatomic, strong) NSMutableDictionary *observerEntries;
@end

@implementation GCDefaultEventBus
@synthesize observerEntries = _observerEntries;

- (id)init {
    self = [super init];
    if (self) {
        self.observerEntries = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addObserver:(id)observer forEvent:(Class)eventClass withSelector:(SEL)selector priority:(int)priority {
    if (![self hasObserver:observer forEvent:eventClass withSelector:selector])
        [self insertObserverEntry:[[GCObserverEntry alloc] initWithObserver:observer event:eventClass selector:selector priority:priority]
              intoObserverEntries:[self getObserverEntriesForEvent:eventClass] withPriority:priority];
}

- (void)removeObserver:(id)observer fromEvent:(Class)eventClass withSelector:(SEL)selector {
    NSMutableArray *observerEntriesForEvent = [self getObserverEntriesForEvent:eventClass];
    for (GCObserverEntry *entry in [observerEntriesForEvent copy])
        if ([entry.observer isEqual:observer] && selector == entry.selector)
            [observerEntriesForEvent removeObject:entry];
}

- (void)removeObserver:(id)observer fromEvent:(Class)eventClass {
    NSMutableArray *observerEntriesForEventKey = [self getObserverEntriesForEvent:eventClass];
    for (GCObserverEntry *entry in [observerEntriesForEventKey copy])
        if ([entry.observer isEqual:observer])
            [observerEntriesForEventKey removeObject:entry];
}

- (void)removeObserver:(id)observer {
    for (NSArray *observerEntriesForEventKey in [self.observerEntries allValues])
        for (GCObserverEntry *entry in observerEntriesForEventKey)
            [self removeObserver:entry.observer fromEvent:entry.eventClass];
}

- (void)removeAllObservers {
    [self.observerEntries removeAllObjects];
}

- (void)postEvent:(id <GCEvent>)event {
    for (GCObserverEntry *entry in [self getObserverEntriesForEvent:[event class]])
        [entry execute:event];
}

- (BOOL)hasObserver:(id)observer forEvent:(Class)eventClass withSelector:(SEL)selector {
    for (GCObserverEntry *entry in [self getObserverEntriesForEvent:eventClass])
        if ([entry.observer isEqual:observer] && entry.selector == selector)
            return true;

    return NO;
}

- (BOOL)hasObserver:(id)observer forEvent:(Class)eventClass {
    return [self hasObserver:observer forEventKey:NSStringFromClass(eventClass)];
}

- (BOOL)hasObserver:(id)observer {
    for (NSString *key in self.observerEntries)
        if ([self hasObserver:observer forEventKey:key])
            return YES;

    return NO;
}


#pragma mark private

- (void)insertObserverEntry:(GCObserverEntry *)observerEntry intoObserverEntries:(NSMutableArray *)observerEntriesForEvent withPriority:(int)priority {
    GCObserverEntry *existingEntry;
    for (NSUInteger i = 0; i < observerEntriesForEvent.count; i++) {
        existingEntry = observerEntriesForEvent[i];
        if (existingEntry.priority < priority) {
            [observerEntriesForEvent insertObject:observerEntry atIndex:i];

            return;
        }
    }
    [observerEntriesForEvent addObject:observerEntry];
}

- (NSMutableArray *)getObserverEntriesForEvent:(Class)eventClass {
    return [self getObserverEntriesForEventKey:NSStringFromClass(eventClass)];
}

- (NSMutableArray *)getObserverEntriesForEventKey:(NSString *)key {
    NSMutableArray *observerEntriesForName = self.observerEntries[key];
    if (!observerEntriesForName) {
        observerEntriesForName = [[NSMutableArray alloc] init];
        self.observerEntries[key] = observerEntriesForName;
    }

    return observerEntriesForName;
}

- (BOOL)hasObserver:(id)observer forEventKey:(NSString *)key {
    for (GCObserverEntry *entry in [self getObserverEntriesForEventKey:key])
        if ([entry.observer isEqual:observer])
            return true;

    return NO;
}

@end