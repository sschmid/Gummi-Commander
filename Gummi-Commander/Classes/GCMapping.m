//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GCMapping.h"

@interface GCMapping ()
@property(nonatomic, readwrite, strong) Class commandClass;
@property(nonatomic, readwrite, strong) Class objectClass;
@property(nonatomic, readwrite) int priority;
@property(nonatomic, readwrite) BOOL remove;
@property(nonatomic, readwrite, strong) NSArray *guards;
@end

@implementation GCMapping

- (id)initWithCommand:(Class)commandClass object:(Class)objectClass priority:(int)priority remove:(BOOL)remove {
    self = [super init];
    if (self) {
        self.commandClass = commandClass;
        self.objectClass = objectClass;
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
