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
#import "GRReflection.h"

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

- (GCMapping *)mapAction:(id)action toTrigger:(Class)trigger {
    return [self mapAction:action toTrigger:trigger priority:0 removeMappingAfterExecution:NO];
}

- (GCMapping *)mapAction:(id)action toTrigger:(Class)trigger priority:(int)priority {
    return [self mapAction:action toTrigger:trigger priority:priority removeMappingAfterExecution:NO];
}

- (GCMapping *)mapAction:(id)action toTrigger:(Class)trigger removeMappingAfterExecution:(BOOL)remove {
    return [self mapAction:action toTrigger:trigger priority:0 removeMappingAfterExecution:remove];
}

- (GCMapping *)mapAction:(id)action toTrigger:(Class)trigger priority:(int)priority removeMappingAfterExecution:(BOOL)remove {
    [self.dispatcher addObserver:self forObject:trigger withSelector:@selector(executeAction:) priority:priority];
    GCMapping *mapping = [[GCMapping alloc] initWithAction:action trigger:trigger priority:priority remove:remove];
    [self insertMapping:mapping intoMappingsForTrigger:[self getMappingsForTrigger:trigger] withPriority:priority];
    return mapping;
}

- (GCMapping *)autoMapTrigger:(Class)trigger {
    NSString *triggerName = NSStringFromClass(trigger);

    NSRange startRange = [triggerName rangeOfString:@"Event"];
    if (startRange.location == NSNotFound)
        @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@Exception", NSStringFromClass([self class])]
           reason:[NSString stringWithFormat:@"The trigger '%@' doesn't follow the naming convention. Auto mapped triggers must end with 'Event'", triggerName]
         userInfo:nil];

    NSString *name = [triggerName substringToIndex:startRange.location];
    NSString *actionName = [name stringByAppendingString:@"Command"];

    Class action = NSClassFromString(actionName);
    if (!action)
        @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@Exception", NSStringFromClass([self class])]
           reason:[NSString stringWithFormat:@"Couldn't auto map '%@'. Class '%@' does not exist.", triggerName, actionName]
         userInfo:nil];

    return [self mapAction:action toTrigger:trigger];
}

- (GCMapping *)mappingForAction:(id)action mappedToTrigger:(Class)trigger {
    for (GCMapping *mapping in [self getMappingsForTrigger:trigger])
        if ([mapping.action isEqual:action])
            return mapping;

    return nil;
}

- (void)unMapAction:(id)action fromTrigger:(Class)trigger {
    NSMutableArray *mappingsForTrigger = [self getMappingsForTrigger:trigger];
    for (GCMapping *mapping in [mappingsForTrigger copy]) {
        if ([mapping.action isEqual:action]) {
            [mappingsForTrigger removeObject:mapping];
            if (mappingsForTrigger.count == 0)
                [self.dispatcher removeObserver:self fromObject:trigger];

            return;
        }
    }
}

- (void)unMapAll {
    [self.map removeAllObjects];
    [self.dispatcher removeObserver:self];
}

- (BOOL)isAction:(id)action mappedToTrigger:(Class)trigger {
    for (GCMapping *mapping in [self getMappingsForTrigger:trigger])
        if ([mapping.action isEqual:action])
            return YES;

    return NO;
}


#pragma mark private

- (void)insertMapping:(GCMapping *)mapping intoMappingsForTrigger:(NSMutableArray *)mappingsForTrigger withPriority:(int)priority {
    GCMapping *existingMapping;
    for (NSUInteger i = 0; i < mappingsForTrigger.count; i++) {
        existingMapping = mappingsForTrigger[i];
        if (existingMapping.priority < priority) {
            [mappingsForTrigger insertObject:mapping atIndex:i];

            return;
        }
    }

    [mappingsForTrigger addObject:mapping];
}

- (NSMutableArray *)getMappingsForTrigger:(Class)trigger {
    NSString *key = NSStringFromClass(trigger);
    NSMutableArray *mappingsForTrigger = self.map[key];
    if (!mappingsForTrigger) {
        mappingsForTrigger = [[NSMutableArray alloc] init];
        self.map[key] = mappingsForTrigger;
    }

    return mappingsForTrigger;
}

- (void)executeAction:(id)trigger {
    [self.injector map:trigger to:[trigger class]];
    for (GCMapping *mapping in [[self getMappingsForTrigger:[trigger class]] copy]) {
        if ([self allGuardsApprove:mapping.guards]) {

            if ([GRReflection isClass:mapping.action]) {
                [[self.injector getObject:mapping.action] execute];
            } else if ([GRReflection isBlock:mapping.action]) {
                GCGIBlockAction(blockAction) = mapping.action;
                blockAction(self.injector);
            }
            
            if (mapping.remove)
                [self unMapAction:mapping.action fromTrigger:mapping.trigger];
        }
    }
    [self.injector unMap:trigger from:[trigger class]];
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