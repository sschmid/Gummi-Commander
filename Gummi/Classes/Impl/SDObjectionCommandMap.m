//
// Created by sschmid on 20.11.12.
//
// contact@sschmid.com
//


#import "SDObjectionCommandMap.h"
#import "Objection.h"
#import "SDEventBus.h"
#import "SDCommand.h"
#import "SDEventCommandMapping.h"
#import "SDGuard.h"

static NSString *const kMappingModuleName = @"__temp_command_mapping__";
static NSString *const kGuardModuleName = @"__temp_guard_mapping__";

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

- (SDEventCommandMapping *)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass {
    return [self mapEventClass:eventClass toCommandClass:commandClass priority:0 removeMappingAfterExecution:NO];
}

- (SDEventCommandMapping *)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass priority:(int)priority {
    return [self mapEventClass:eventClass toCommandClass:commandClass priority:priority removeMappingAfterExecution:NO];
}

- (SDEventCommandMapping *)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass removeMappingAfterExecution:(BOOL)remove {
    return [self mapEventClass:eventClass toCommandClass:commandClass priority:0 removeMappingAfterExecution:remove];
}

- (SDEventCommandMapping *)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass priority:(int)priority removeMappingAfterExecution:(BOOL)remove {
    NSString *key = NSStringFromClass(eventClass);
    NSMutableArray *mappingsForEvent = [self.map objectForKey:key];
    if (!mappingsForEvent) {
        mappingsForEvent = [[NSMutableArray alloc] init];
        [self.map setObject:mappingsForEvent forKey:key];
    }

    if (![self.eventBus hasObserver:self selector:@selector(executeCommand:) name:key])
        [self.eventBus addObserver:self selector:@selector(executeCommand:) name:key priority:priority];

    SDEventCommandMapping *mapping;
    SDEventCommandMapping *eventCommandMapping;
    NSUInteger n = mappingsForEvent.count;
    for (NSUInteger i = 0; i < n; i++) {
        mapping = [mappingsForEvent objectAtIndex:i];
        if (mapping.priority < priority) {
            eventCommandMapping = [[SDEventCommandMapping alloc] initWithEventClass:eventClass commandClass:commandClass priority:priority remove:remove];
            [mappingsForEvent insertObject:eventCommandMapping atIndex:i];
            return eventCommandMapping;
        }
    }
    eventCommandMapping = [[SDEventCommandMapping alloc] initWithEventClass:eventClass commandClass:commandClass priority:priority remove:remove];
    [mappingsForEvent addObject:eventCommandMapping];
    return eventCommandMapping;
}

- (SDEventCommandMapping *)mappingForEventClass:(Class)eventClass commandClass:(Class)commandClass {
    for (SDEventCommandMapping *mapping in [self.map objectForKey:NSStringFromClass(eventClass)])
        if (mapping.commandClass == commandClass)
            return mapping;

    return nil;
}

- (void)unMapEventClass:(Class)eventClass fromCommandClass:(Class)commandClass {
    NSString *key = NSStringFromClass(eventClass);
    NSMutableArray *mappingsForEvent = [self.map objectForKey:key];
    for (SDEventCommandMapping *mapping in [mappingsForEvent copy]) {
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
    for (SDEventCommandMapping *mapping in [self.map objectForKey:NSStringFromClass(eventClass)])
        if (mapping.commandClass == commandClass)
            return YES;

    return NO;
}


#pragma mark private

- (void)executeCommand:(NSObject <SDEvent> *)event {
    JSObjectionModule *mappingModule = [[JSObjectionModule alloc] init];
    NSMutableArray *mappingsForEvent = [self.map objectForKey:NSStringFromClass([event class])];
    for (SDEventCommandMapping *mapping in [mappingsForEvent copy]) {
        // Temporarily bind event and command
        [mappingModule bind:event toClass:[event class]];
        [mappingModule bindClass:mapping.commandClass toClass:mapping.commandClass asSingleton:NO];
        [self.injector addModule:mappingModule withName:kMappingModuleName];

        if ([self allGuardsApprove:mapping.guards]) {
            // Execute command
            [[self.injector getObject:mapping.commandClass] execute];
            if (mapping.remove)
                [self unMapEventClass:mapping.eventClass fromCommandClass:mapping.commandClass];
        }

        // Remove temp bindings
        [self.injector removeModuleWithName:kMappingModuleName];
        [mappingModule reset];
    }

}

- (BOOL)allGuardsApprove:(NSArray *)guards {
    JSObjectionModule *guardModule = [[JSObjectionModule alloc] init];
    BOOL approve = YES;
    for (Class guardClass in guards) {
        [guardModule bindClass:guardClass toClass:guardClass asSingleton:NO];
        [self.injector addModule:guardModule withName:kGuardModuleName];

        approve = [[self.injector getObject:guardClass] approve];

        [self.injector removeModuleWithName:kGuardModuleName];
        [guardModule reset];

        if (!approve)
            return NO;
    }

    return YES;
}

@end