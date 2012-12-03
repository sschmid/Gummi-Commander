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
    [self.eventBus addObserver:self selector:@selector(executeCommand:) name:key priority:priority];
    SDEventCommandMapping *eventCommandMapping = [[SDEventCommandMapping alloc] initWithEventClass:eventClass commandClass:commandClass priority:priority remove:remove];
    [self insertMapping:eventCommandMapping intoMappingsForEvent:[self getMappingsForEventKey:key] withPriority:priority];
    return eventCommandMapping;
}

- (SDEventCommandMapping *)mappingForEventClass:(Class)eventClass commandClass:(Class)commandClass {
    for (SDEventCommandMapping *mapping in [self getMappingsForEventKey:NSStringFromClass(eventClass)])
        if (mapping.commandClass == commandClass)
            return mapping;

    return nil;
}

- (void)unMapEventClass:(Class)eventClass fromCommandClass:(Class)commandClass {
    NSString *key = NSStringFromClass(eventClass);
    NSMutableArray *mappingsForEvent = [self getMappingsForEventKey:key];
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
    for (SDEventCommandMapping *mapping in [self getMappingsForEventKey:NSStringFromClass(eventClass)])
        if (mapping.commandClass == commandClass)
            return YES;

    return NO;
}


#pragma mark private

- (void)insertMapping:(SDEventCommandMapping *)eventCommandMapping intoMappingsForEvent:(NSMutableArray *)mappingsForEvent withPriority:(int)priority {
    SDEventCommandMapping *existingMapping;
    for (NSUInteger i = 0; i < mappingsForEvent.count; i++) {
        existingMapping = [mappingsForEvent objectAtIndex:i];
        if (existingMapping.priority < priority) {
            [mappingsForEvent insertObject:eventCommandMapping atIndex:i];
            return;
        }
    }
    [mappingsForEvent addObject:eventCommandMapping];
}

- (NSMutableArray *)getMappingsForEventKey:(NSString *)key {
    NSMutableArray *mappingsForEvent = [self.map objectForKey:key];
    if (!mappingsForEvent) {
        mappingsForEvent = [[NSMutableArray alloc] init];
        [self.map setObject:mappingsForEvent forKey:key];
    }

    return mappingsForEvent;
}

- (void)executeCommand:(NSObject <SDEvent> *)event {
    JSObjectionModule *mappingModule = [[JSObjectionModule alloc] init];
    for (SDEventCommandMapping *mapping in [[self getMappingsForEventKey:NSStringFromClass([event class])] copy]) {
        [self temporarilyBindEvent:event andCommandClass:mapping.commandClass usingModule:mappingModule];
        if ([self allGuardsApprove:mapping.guards]) {
            [[self.injector getObject:mapping.commandClass] execute];
            if (mapping.remove)
                [self unMapEventClass:mapping.eventClass fromCommandClass:mapping.commandClass];
        }
        [self removeTempModule:mappingModule];
    }
}

- (void)temporarilyBindEvent:(NSObject <SDEvent> *)event andCommandClass:(Class)commandClass usingModule:(JSObjectionModule *)module {
    [module bind:event toClass:[event class]];
    [module bindClass:commandClass toClass:commandClass asSingleton:NO];
    [self.injector addModule:module];
}

- (void)removeTempModule:(JSObjectionModule *)module {
    [self.injector removeModuleInstance:module];
    [module reset];
}

- (BOOL)allGuardsApprove:(NSArray *)guards {
    BOOL approve;
    JSObjectionModule *guardModule = [[JSObjectionModule alloc] init];
    for (Class guardClass in guards) {
        [self temporarilyBindGuard:guardClass usingModule:guardModule];
        approve = [[self.injector getObject:guardClass] approve];
        [self removeTempModule:guardModule];
        if (!approve)
            return NO;
    }

    return YES;
}

- (void)temporarilyBindGuard:(Class)guardClass usingModule:(JSObjectionModule *)module {
    [module bindClass:guardClass toClass:guardClass asSingleton:NO];
    [self.injector addModule:module];
}

@end