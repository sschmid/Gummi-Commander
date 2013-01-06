//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GCDefaultEventBus.h"
#import "GCObserverEntry.h"

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

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName priority:(int)priority {
    if (![self hasObserver:observer selector:aSelector name:aName])
        [self insertObserverEntry:[[GCObserverEntry alloc] initWithObserver:observer selector:aSelector priority:priority]
              intoObserverEntries:[self getObserverEntriesForName:aName] withPriority:priority];
}

- (void)removeObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName {
    NSMutableArray *observerEntriesForName = [self getObserverEntriesForName:aName];
    for (GCObserverEntry *entry in [observerEntriesForName copy])
        if (entry.observer == observer && aSelector == entry.selector)
            [observerEntriesForName removeObject:entry];
}

- (void)removeObserver:(id)observer name:(NSString *)aName {
    NSMutableArray *observerEntriesForName = [self getObserverEntriesForName:aName];
    for (GCObserverEntry *entry in [observerEntriesForName copy])
        if (entry.observer == observer)
            [observerEntriesForName removeObject:entry];
}

- (void)removeObserver:(id)observer {
    for (NSString *key in self.observerEntries)
        [self removeObserver:observer name:key];
}

- (void)removeAllObservers {
    [self.observerEntries removeAllObjects];
}

- (void)postEvent:(id <GCEvent>)event {
    for (GCObserverEntry *entry in [self getObserverEntriesForName:event.name])
        [entry execute:event];
}

- (BOOL)hasObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName {
    for (GCObserverEntry *entry in [self getObserverEntriesForName:aName])
        if (entry.observer == observer && entry.selector == aSelector)
            return true;

    return NO;
}

- (BOOL)hasObserver:(id)observer name:(NSString *)aName {
    for (GCObserverEntry *entry in [self getObserverEntriesForName:aName])
        if (entry.observer == observer)
            return true;

    return NO;
}

- (BOOL)hasObserver:(id)observer {
    for (NSString *key in self.observerEntries)
        if ([self hasObserver:observer name:key])
            return YES;

    return NO;
}


#pragma mark private

- (void)insertObserverEntry:(GCObserverEntry *)observerEntry intoObserverEntries:(NSMutableArray *)observerEntriesForName withPriority:(int)priority {
    GCObserverEntry *existingEntry;
    for (NSUInteger i = 0; i < observerEntriesForName.count; i++) {
        existingEntry = observerEntriesForName[i];
        if (existingEntry.priority < priority) {
            [observerEntriesForName insertObject:observerEntry atIndex:i];

            return;
        }
    }
    [observerEntriesForName addObject:observerEntry];
}

- (NSMutableArray *)getObserverEntriesForName:(NSString *)aName {
    NSMutableArray *observerEntriesForName = self.observerEntries[aName];
    if (!observerEntriesForName) {
        observerEntriesForName = [[NSMutableArray alloc] init];
        self.observerEntries[aName] = observerEntriesForName;
    }

    return observerEntriesForName;
}

@end