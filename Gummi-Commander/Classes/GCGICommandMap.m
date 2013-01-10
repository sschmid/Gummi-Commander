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
@synthesize dispatcher = _dispatcher;
@synthesize injector = _injector;
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
    [self.dispatcher addObserver:self forObject:event withSelector:@selector(executeCommand:) priority:priority];
    GCMapping *mapping = [[GCMapping alloc] initWithEvent:event command:command priority:priority remove:remove];
    [self insertMapping:mapping intoMappingsForEvent:[self getMappingsForEvent:event] withPriority:priority];
    return mapping;
}

- (GCMapping *)mappingForEvent:(Class)event command:(Class)command {
    for (GCMapping *mapping in [self getMappingsForEvent:event])
        if ([mapping.commandClass isEqual:command])
            return mapping;

    return nil;
}

- (void)unMapEvent:(Class)event fromCommand:(Class)command {
    NSMutableArray *mappingsForEvent = [self getMappingsForEvent:event];
    for (GCMapping *mapping in [mappingsForEvent copy]) {
        if ([mapping.commandClass isEqual:command]) {
            [mappingsForEvent removeObject:mapping];
            if (mappingsForEvent.count == 0)
                [self.dispatcher removeObserver:self fromObject:event];

            return;
        }
    }
}

- (void)unMapAll {
    [self.map removeAllObjects];
    [self.dispatcher removeObserver:self];
}

- (BOOL)isEvent:(Class)event mappedToCommand:(Class)command {
    for (GCMapping *mapping in [self getMappingsForEvent:event])
        if ([mapping.commandClass isEqual:command])
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