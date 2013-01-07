//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GCGIEvent.h"
#import "GCEventBus.h"
#import "GIInjector.h"

@interface GCGIEvent ()
@property(nonatomic, copy) NSString *name;
@end

@implementation GCGIEvent

+ (void)dispatch {
    [[[self alloc] init] dispatch];
}

- (id)init {
    return [self initWithName:NSStringFromClass([self class])];
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
    }

    return self;
}

- (void)dispatch {
    id <GCEventBus> eventBus = [[GIInjector sharedInjector] getObject:@protocol(GCEventBus)];
    [eventBus postEvent:self];
}

@end