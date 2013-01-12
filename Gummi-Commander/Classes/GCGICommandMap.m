//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GCGICommandMap.h"
#import "GIInjector.h"
#import "GCCommand.h"
#import "GCGuard.h"
#import "GDDispatcher.h"

@interface GCGICommandMap ()
@property(nonatomic, strong) NSMutableDictionary *map;
@end

@implementation GCGICommandMap
inject(@"dispatcher", @"injector")

- (id)init {
    self = [super init];
    if (self) {
        self.map = [NSMutableDictionary dictionary];
    }
    return self;
}

- (GCMapping *)mapCommand:(Class)commandClass toEvent:(Class)eventClass {
    return [self mapCommand:commandClass toEvent:eventClass priority:0 removeMappingAfterExecution:NO];
}

- (GCMapping *)mapCommand:(Class)commandClass toEvent:(Class)eventClass priority:(int)priority {
    return [self mapCommand:commandClass toEvent:eventClass priority:priority removeMappingAfterExecution:NO];
}

- (GCMapping *)mapCommand:(Class)commandClass toEvent:(Class)eventClass removeMappingAfterExecution:(BOOL)remove {
    return [self mapCommand:commandClass toEvent:eventClass priority:0 removeMappingAfterExecution:remove];
}

- (GCMapping *)mapCommand:(Class)commandClass toEvent:(Class)eventClass priority:(int)priority removeMappingAfterExecution:(BOOL)remove {
    [self.dispatcher addObserver:self forObject:eventClass withSelector:@selector(executeCommand:) priority:priority];
    GCMapping *mapping = [[GCMapping alloc] initWithEvent:eventClass command:commandClass priority:priority remove:remove];
    [self insertMapping:mapping intoMappingsForEvent:[self getMappingsForEvent:eventClass] withPriority:priority];
    return mapping;
}

- (GCMapping *)mappingForCommand:(Class)commandClass event:(Class)eventClass {
    for (GCMapping *mapping in [self getMappingsForEvent:eventClass])
        if ([mapping.commandClass isEqual:commandClass])
            return mapping;

    return nil;
}

- (void)unMapCommand:(Class)commandClass fromEvent:(Class)eventClass {
    NSMutableArray *mappingsForEvent = [self getMappingsForEvent:eventClass];
    for (GCMapping *mapping in [mappingsForEvent copy]) {
        if ([mapping.commandClass isEqual:commandClass]) {
            [mappingsForEvent removeObject:mapping];
            if (mappingsForEvent.count == 0)
                [self.dispatcher removeObserver:self fromObject:eventClass];

            return;
        }
    }
}

- (void)unMapAll {
    [self.map removeAllObjects];
    [self.dispatcher removeObserver:self];
}

- (BOOL)isCommand:(Class)commandClass mappedToEvent:(Class)eventClass {
    for (GCMapping *mapping in [self getMappingsForEvent:eventClass])
        if ([mapping.commandClass isEqual:commandClass])
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

- (NSMutableArray *)getMappingsForEvent:(Class)event {
    NSString *key = NSStringFromClass(event);
    NSMutableArray *mappingsForEvent = self.map[key];
    if (!mappingsForEvent) {
        mappingsForEvent = [[NSMutableArray alloc] init];
        self.map[key] = mappingsForEvent;
    }

    return mappingsForEvent;
}

- (void)executeCommand:(id)event {
    for (GCMapping *mapping in [[self getMappingsForEvent:[event class]] copy]) {
        [self.injector map:event to:[event class]];
        if ([self allGuardsApprove:mapping.guards]) {
            [[self.injector getObject:mapping.commandClass] execute];
            if (mapping.remove)
                [self unMapCommand:mapping.commandClass fromEvent:mapping.eventClass];
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