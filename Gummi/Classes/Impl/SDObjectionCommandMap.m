//
// Created by sschmid on 20.11.12.
//
// contact@sschmid.com
//


#pragma mark GUEventCommandMapping

#import "SDObjectionCommandMap.h"
#import "Objection.h"
#import "SDEventBus.h"
#import "SDCommand.h"

static NSString *const kModuleName = @"__temp_command_mapping__";

@interface GUEventCommandMapping : NSObject
@property(nonatomic, strong) Class eventClass;
@property(nonatomic, strong) Class commandClass;
@property(nonatomic) int priority;
@property(nonatomic) BOOL remove;
@end

@implementation GUEventCommandMapping
@synthesize eventClass = _eventClass;
@synthesize commandClass = _commandClass;
@synthesize priority = _priority;
@synthesize remove = _remove;


- (id)initWithEventClass:(Class)eventClass commandClass:(Class)commandClass priority:(int)priority remove:(BOOL)remove{
    self = [super init];
    if (self) {
        self.eventClass = eventClass;
        self.commandClass = commandClass;
        self.priority = priority;
        self.remove = remove;
    }
    return self;
}


@end


#pragma mark GUObjectionCommandMap

@interface SDObjectionCommandMap ()
@property(nonatomic, strong) NSMutableDictionary *map;

@end


@implementation SDObjectionCommandMap

objection_requires(@"injector", @"eventBus")
@synthesize injector = _injector;
@synthesize eventBus = _eventBus;
@synthesize map = _map;


- (id)init {
    self = [super init];
    if (self) {
        self.map = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass {
    [self mapEventClass:eventClass toCommandClass:commandClass priority:0 removeMappingAfterExecution:NO];
}

- (void)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass priority:(int)priority {
    [self mapEventClass:eventClass toCommandClass:commandClass priority:priority removeMappingAfterExecution:NO];
}

- (void)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass removeMappingAfterExecution:(BOOL)remove {
    [self mapEventClass:eventClass toCommandClass:commandClass priority:0 removeMappingAfterExecution:remove];
}

- (void)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass priority:(int)priority removeMappingAfterExecution:(BOOL)remove {
    NSString *key = NSStringFromClass(eventClass);
    NSMutableArray *mappingsForEvent = [self.map objectForKey:key];
    if (!mappingsForEvent) {
        mappingsForEvent = [[NSMutableArray alloc] init];
        [self.map setObject:mappingsForEvent forKey:key];
    }

    if (![self.eventBus hasObserver:self selector:@selector(executeCommand:) name:key])
        [self.eventBus addObserver:self selector:@selector(executeCommand:) name:key priority:priority];

    GUEventCommandMapping *mapping;
    NSUInteger n = mappingsForEvent.count;
    for (NSUInteger i = 0; i < n; i++) {
        mapping = [mappingsForEvent objectAtIndex:i];
        if (mapping.priority < priority) {
            [mappingsForEvent insertObject:[[GUEventCommandMapping alloc] initWithEventClass:eventClass commandClass:commandClass priority:priority remove:remove] atIndex:i];

            return;
        }
    }
    [mappingsForEvent addObject:[[GUEventCommandMapping alloc] initWithEventClass:eventClass commandClass:commandClass priority:priority remove:remove]];
}

- (void)unMapEventClass:(Class)eventClass fromCommandClass:(Class)commandClass {
    NSString *key = NSStringFromClass(eventClass);
    NSMutableArray *mappingsForEvent = [self.map objectForKey:key];
    for (GUEventCommandMapping *mapping in [mappingsForEvent copy]) {
        if (mapping.commandClass == commandClass) {
            [mappingsForEvent removeObject:mapping];
            if (mappingsForEvent.count == 0)
                [self.eventBus removeObserver:self name:key];
        }
    }
}

- (void)unMapAll {
    [self.map removeAllObjects];
    [self.eventBus removeObserver:self];
}

- (BOOL)isEventClass:(Class)eventClass mappedToCommandClass:(Class)commandClass {
    for (GUEventCommandMapping *mapping in [self.map objectForKey:NSStringFromClass(eventClass)])
        if (mapping.commandClass == commandClass)
            return YES;

    return NO;
}


#pragma mark private

- (void)executeCommand:(NSObject <SDEvent> *)event {
    JSObjectionModule *module = [[JSObjectionModule alloc] init];
    NSMutableArray *mappingsForEvent = [self.map objectForKey:NSStringFromClass([event class])];
    for (GUEventCommandMapping *mapping in [mappingsForEvent copy]) {
        [module bind:event toClass:[event class]];
        [module bindClass:mapping.commandClass toClass:mapping.commandClass asSingleton:NO];
        [self.injector addModule:module withName:kModuleName];

        [[self.injector getObject:mapping.commandClass] execute];

        [self.injector removeModuleWithName:kModuleName];
        [module reset];
        if (mapping.remove)
            [self unMapEventClass:mapping.eventClass fromCommandClass:mapping.commandClass];
    }
}

@end