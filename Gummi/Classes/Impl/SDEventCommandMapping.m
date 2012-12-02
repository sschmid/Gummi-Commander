//
// Created by sschmid on 30.11.12.
//
// contact@sschmid.com
//


#import "SDEventCommandMapping.h"


@interface SDEventCommandMapping ()
@property(nonatomic, readwrite, strong) Class eventClass;
@property(nonatomic, readwrite, strong) Class commandClass;
@property(nonatomic, readwrite) int priority;
@property(nonatomic, readwrite) BOOL remove;
@property(nonatomic, readwrite, strong) NSArray *guards;

@end

@implementation SDEventCommandMapping
@synthesize eventClass = _eventClass;
@synthesize commandClass = _commandClass;
@synthesize priority = _priority;
@synthesize remove = _remove;
@synthesize guards = _guards;


- (id)initWithEventClass:(Class)eventClass commandClass:(Class)commandClass priority:(int)priority remove:(BOOL)remove {
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
