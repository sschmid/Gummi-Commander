//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GCMapping.h"

@interface GCMapping ()
@property(nonatomic, readwrite) id action;
@property(nonatomic, readwrite, strong) Class trigger;
@property(nonatomic, readwrite) int priority;
@property(nonatomic, readwrite) BOOL remove;
@property(nonatomic, readwrite, strong) NSArray *guards;
@end

@implementation GCMapping

- (id)initWithAction:(id)action trigger:(Class)trigger priority:(int)priority remove:(BOOL)remove {
    self = [super init];
    if (self) {
        self.action = action;
        self.trigger = trigger;
        self.priority = priority;
        self.remove = remove;
    }
    return self;
}

- (void)withGuards:(NSArray *)guards {
    self.guards = guards;
}

- (BOOL)hasGuard:(Class)guardClass {
    return [self.guards containsObject:guardClass];
}

@end
