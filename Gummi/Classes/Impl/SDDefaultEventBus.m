//
// Created by sschmid on 20.11.12.
//
// contact@sschmid.com
//


#pragma mark SDObserverEntry

#import "SDDefaultEventBus.h"

@interface SDObserverEntry : NSObject
@property(nonatomic, strong) id observer;
@property(nonatomic) SEL selector;
@property(nonatomic) int priority;

- (id)initWithObserver:(id)observer selector:(SEL)selector priority:(int)priority;
- (void)execute:(id <SDEvent>)event;

@end

@implementation SDObserverEntry
@synthesize observer = _observer;
@synthesize selector = _selector;
@synthesize priority = _priority;

- (id)initWithObserver:(id)observer selector:(SEL)aSelector priority:(int)priority {
    self = [super init];
    if (self) {
        self.observer = observer;
        self.selector = aSelector;
        self.priority = priority;
    }

    return self;
}

- (void)execute:(id <SDEvent>)event {
    [self.observer performSelector:self.selector withObject:event];
}

@end


#pragma mark SDDefaultEventBus

@interface SDDefaultEventBus ()
@property(nonatomic, strong) NSMutableDictionary *observerEntries;

@end

@implementation SDDefaultEventBus
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
        [self insertObserverEntry:[[SDObserverEntry alloc] initWithObserver:observer selector:aSelector priority:priority]
              intoObserverEntries:[self getObserverEntriesForName:aName] withPriority:priority];
}

- (void)removeObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName {
    NSMutableArray *observerEntriesForName = [self getObserverEntriesForName:aName];
    for (SDObserverEntry *entry in [observerEntriesForName copy])
        if (entry.observer == observer && aSelector == entry.selector)
            [observerEntriesForName removeObject:entry];
}

- (void)removeObserver:(id)observer name:(NSString *)aName {
    NSMutableArray *observerEntriesForName = [self getObserverEntriesForName:aName];
    for (SDObserverEntry *entry in [observerEntriesForName copy])
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

- (void)postEvent:(id <SDEvent>)event {
    for (SDObserverEntry *entry in [self getObserverEntriesForName:event.name])
        [entry execute:event];
}

- (BOOL)hasObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName {
    for (SDObserverEntry *entry in [self getObserverEntriesForName:aName])
        if (entry.observer == observer && entry.selector == aSelector)
            return true;
    return NO;
}

- (BOOL)hasObserver:(id)observer name:(NSString *)aName {
    for (SDObserverEntry *entry in [self getObserverEntriesForName:aName])
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

- (void)insertObserverEntry:(SDObserverEntry *)observerEntry intoObserverEntries:(NSMutableArray *)observerEntriesForName withPriority:(int)priority {
    SDObserverEntry *existingEntry;
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