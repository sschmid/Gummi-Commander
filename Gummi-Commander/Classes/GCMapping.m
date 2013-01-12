//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GCMapping.h"

@interface GCMapping ()
@property(nonatomic, readwrite, strong) Class eventClass;
@property(nonatomic, readwrite, strong) Class commandClass;
@property(nonatomic, readwrite) int priority;
@property(nonatomic, readwrite) BOOL remove;
@property(nonatomic, readwrite, strong) NSArray *guards;
@end

@implementation GCMapping

- (id)initWithEvent:(Class)eventClass command:(Class)commandClass priority:(int)priority remove:(BOOL)remove {
    self = [super init];
    if (self) {
        self.eventClass = eventClass;
        self.commandClass = commandClass;
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
