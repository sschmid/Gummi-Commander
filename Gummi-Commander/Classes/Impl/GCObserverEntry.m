//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GCObserverEntry.h"
#import "GCEvent.h"


@implementation GCObserverEntry
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

- (void)execute:(id <GCEvent>)event {
    [self.observer performSelector:self.selector withObject:event];
}

@end
