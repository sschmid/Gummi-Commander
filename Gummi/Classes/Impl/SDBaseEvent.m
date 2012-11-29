//
// Created by sschmid on 27.11.12.
//
// contact@sschmid.com
//


#import "SDBaseEvent.h"
#import "SDEventBus.h"
#import "Objection.h"

@interface SDBaseEvent ()
@property(nonatomic, strong) NSString *name;
@end

@implementation SDBaseEvent

- (id)init {
    self = [self initWithName:NSStringFromClass([self class])];
    return self;
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
    }

    return self;
}

- (void)dispatch {
    id <SDEventBus>eventBus = [[JSObjection defaultInjector] getObject:@protocol(SDEventBus)];
    [eventBus postEvent:self];
}

+ (void)dispatch {
    [[[self alloc] init] dispatch];
}
@end