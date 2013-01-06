//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GCGICommandMap.h"
#import "GIInjector.h"
#import "GCEventBus.h"
#import "GCCommand.h"
#import "GCGuard.h"

@interface GCGICommandMap ()
@property(nonatomic, strong) NSMutableDictionary *map;
@end

@implementation GCGICommandMap

inject(@"injector", @"eventBus")
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

- (GCMapping *)mapEvent:(Class)event toCommand:(Class)command {
    return [self mapEvent:event toCommand:command priority:0 removeMappingAfterExecution:NO];
}

- (GCMapping *)mapEvent:(Class)event toCommand:(Class)command priority:(int)priority {
    return [self mapEvent:event toCommand:command priority:priority removeMappingAfterExecution:NO];
}

- (GCMapping *)mapEvent:(Class)event toCommand:(Class)command removeMappingAfterExecution:(BOOL)remove {
    return [self mapEvent:event toCommand:command priority:0 removeMappingAfterExecution:remove];
}

- (GCMapping *)mapEvent:(Class)event toCommand:(Class)command priority:(int)priority removeMappingAfterExecution:(BOOL)remove {
    NSString *key = NSStringFromClass(event);
    [self.eventBus addObserver:self selector:@selector(executeCommand:) name:key priority:priority];
    GCMapping *mapping = [[GCMapping alloc] initWithEventClass:event commandClass:command priority:priority remove:remove];
    [self insertMapping:mapping intoMappingsForEvent:[self getMappingsForEventKey:key] withPriority:priority];
    return mapping;
}

- (GCMapping *)mappingForEvent:(Class)event command:(Class)command {
    for (GCMapping *mapping in [self getMappingsForEventKey:NSStringFromClass(event)])
        if (mapping.commandClass == command)
            return mapping;

    return nil;
}

- (void)unMapEvent:(Class)event fromCommand:(Class)command {
    NSString *key = NSStringFromClass(event);
    NSMutableArray *mappingsForEvent = [self getMappingsForEventKey:key];
    for (GCMapping *mapping in [mappingsForEvent copy]) {
        if (mapping.commandClass == command) {
            [mappingsForEvent removeObject:mapping];
            if (mappingsForEvent.count == 0)
                [self.eventBus removeObserver:self name:key];

            return;
        }
    }
}

- (void)unMapAll {
    [self.map removeAllObjects];
    [self.eventBus removeObserver:self];
}

- (BOOL)isEvent:(Class)event mappedToCommand:(Class)command {
    for (GCMapping *mapping in [self getMappingsForEventKey:NSStringFromClass(event)])
        if (mapping.commandClass == command)
            return YES;

    return NO;
}


#pragma mark private

- (void)insertMapping:(GCMapping *)mapping intoMappingsForEvent:(NSMutableArray *)mappingsForEvent withPriority:(int)priority {
    GCMapping *existingMapping;
    for (NSUInteger i = 0; i < mappingsForEvent.count; i++) {
        existingMapping = mappingsForEvent[i];
        if (existingMapping.priority < priority) {
            [mappingsForEvent insertObject:mapping atIndex:i];

            return;
        }
    }
    [mappingsForEvent addObject:mapping];
}

- (NSMutableArray *)getMappingsForEventKey:(NSString *)key {
    NSMutableArray *mappingsForEvent = self.map[key];
    if (!mappingsForEvent) {
        mappingsForEvent = [[NSMutableArray alloc] init];
        self.map[key] = mappingsForEvent;
    }

    return mappingsForEvent;
}

- (void)executeCommand:(NSObject <GCEvent> *)event {
    for (GCMapping *mapping in [[self getMappingsForEventKey:NSStringFromClass([event class])] copy]) {
        [self.injector map:event to:[event class]];
        if ([self allGuardsApprove:mapping.guards]) {
            [[self.injector getObject:mapping.commandClass] execute];
            if (mapping.remove)
                [self unMapEvent:mapping.eventClass fromCommand:mapping.commandClass];
        }
        [self.injector unMap:event from:[event class]];
    }
}

- (BOOL)allGuardsApprove:(NSArray *)guards {
    if (guards.count == 0)
        return YES;

    for (Class guardClass in guards)
        if (![[self.injector getObject:guardClass] approve])
            return NO;

    return YES;
}

@end