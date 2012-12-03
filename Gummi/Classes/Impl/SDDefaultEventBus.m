//
// Created by sschmid on 20.11.12.
//
// contact@sschmid.com
//


#pragma mark ObserverEntry

#import "SDDefaultEventBus.h"
#import "SDEvent.h"

@interface GUObserverEntry : NSObject

@property(nonatomic, strong) id observer;
@property(nonatomic) SEL selector;
@property(nonatomic) int priority;

- (id)initWithObserver:(id)observer selector:(SEL)selector priority:(int)priority;

- (void)execute:(id <SDEvent>)event;

@end

@implementation GUObserverEntry
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


#pragma mark GUDefaultEventBus

@interface SDDefaultEventBus ()
@property(nonatomic, strong) NSMutableDictionary *observers;

@end

@implementation SDDefaultEventBus
@synthesize observers = _observers;

- (id)init {
    self = [super init];
    if (self) {
        self.observers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName priority:(int)priority {
    if (![self hasObserver:observer selector:aSelector name:aName])
        [self insertObserverEntry:[[GUObserverEntry alloc] initWithObserver:observer selector:aSelector priority:priority]
              intoObserverEntries:[self getObserverEntriesForName:aName] withPriority:priority];
}

- (void)removeObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName {
    NSMutableArray *observerEntriesForName = [self getObserverEntriesForName:aName];
    for (GUObserverEntry *entry in [observerEntriesForName copy])
        if (entry.observer == observer && aSelector == entry.selector)
            [observerEntriesForName removeObject:entry];
}

- (void)removeObserver:(id)observer name:(NSString *)aName {
    NSMutableArray *observerEntriesForName = [self getObserverEntriesForName:aName];
    for (GUObserverEntry *entry in [observerEntriesForName copy])
        if (entry.observer == observer)
            [observerEntriesForName removeObject:entry];
}

- (void)removeObserver:(id)observer {
    for (NSString *key in self.observers)
        [self removeObserver:observer name:key];
}

- (void)removeAllObservers {
    [self.observers removeAllObjects];
}

- (void)postEvent:(id <SDEvent>)event {
    for (GUObserverEntry *entry in [self getObserverEntriesForName:event.name])
        [entry execute:event];
}

- (BOOL)hasObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName {
    for (GUObserverEntry *entry in [self getObserverEntriesForName:aName])
        if (entry.observer == observer && entry.selector == aSelector)
            return true;
    return NO;
}

- (BOOL)hasObserver:(id)observer name:(NSString *)aName {
    for (GUObserverEntry *entry in [self getObserverEntriesForName:aName])
        if (entry.observer == observer)
            return true;
    return NO;
}

- (BOOL)hasObserver:(id)observer {
    for (NSString *key in self.observers)
        if ([self hasObserver:observer name:key])
            return YES;
    return NO;
}


#pragma mark private

- (void)insertObserverEntry:(GUObserverEntry *)observerEntry intoObserverEntries:(NSMutableArray *)observerEntriesForName withPriority:(int)priority {
    GUObserverEntry *existingEntry;
    for (NSUInteger i = 0; i < observerEntriesForName.count; i++) {
        existingEntry = [observerEntriesForName objectAtIndex:i];
        if (existingEntry.priority < priority) {
            [observerEntriesForName insertObject:observerEntry atIndex:i];

            return;
        }
    }
    [observerEntriesForName addObject:observerEntry];
}

- (NSMutableArray *)getObserverEntriesForName:(NSString *)aName {
    NSMutableArray *observerEntriesForName = [self.observers objectForKey:aName];
    if (!observerEntriesForName) {
        observerEntriesForName = [[NSMutableArray alloc] init];
        [self.observers setObject:observerEntriesForName forKey:aName];
    }

    return observerEntriesForName;
}

@end