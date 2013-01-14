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

- (GCMapping *)mapCommand:(Class)commandClass toObject:(Class)objectClass {
    return [self mapCommand:commandClass toObject:objectClass priority:0 removeMappingAfterExecution:NO];
}

- (GCMapping *)mapCommand:(Class)commandClass toObject:(Class)objectClass priority:(int)priority {
    return [self mapCommand:commandClass toObject:objectClass priority:priority removeMappingAfterExecution:NO];
}

- (GCMapping *)mapCommand:(Class)commandClass toObject:(Class)objectClass removeMappingAfterExecution:(BOOL)remove {
    return [self mapCommand:commandClass toObject:objectClass priority:0 removeMappingAfterExecution:remove];
}

- (GCMapping *)mapCommand:(Class)commandClass toObject:(Class)objectClass priority:(int)priority removeMappingAfterExecution:(BOOL)remove {
    [self.dispatcher addObserver:self forObject:objectClass withSelector:@selector(executeCommand:) priority:priority];
    GCMapping *mapping = [[GCMapping alloc] initWithCommand:commandClass object:objectClass priority:priority remove:remove];
    [self insertMapping:mapping intoMappingsForObject:[self getMappingsForObject:objectClass] withPriority:priority];
    return mapping;
}

- (GCMapping *)mappingForCommand:(Class)commandClass mappedToObject:(Class)objectClass {
    for (GCMapping *mapping in [self getMappingsForObject:objectClass])
        if ([mapping.commandClass isEqual:commandClass])
            return mapping;

    return nil;
}

- (void)unMapCommand:(Class)commandClass fromObject:(Class)objectClass {
    NSMutableArray *mappingsForObject = [self getMappingsForObject:objectClass];
    for (GCMapping *mapping in [mappingsForObject copy]) {
        if ([mapping.commandClass isEqual:commandClass]) {
            [mappingsForObject removeObject:mapping];
            if (mappingsForObject.count == 0)
                [self.dispatcher removeObserver:self fromObject:objectClass];

            return;
        }
    }
}

- (void)unMapAll {
    [self.map removeAllObjects];
    [self.dispatcher removeObserver:self];
}

- (BOOL)isCommand:(Class)commandClass mappedToObject:(Class)objectClass {
    for (GCMapping *mapping in [self getMappingsForObject:objectClass])
        if ([mapping.commandClass isEqual:commandClass])
            return YES;

    return NO;
}


#pragma mark private

- (void)insertMapping:(GCMapping *)mapping intoMappingsForObject:(NSMutableArray *)mappingsForObject withPriority:(int)priority {
    GCMapping *existingMapping;
    for (NSUInteger i = 0; i < mappingsForObject.count; i++) {
        existingMapping = mappingsForObject[i];
        if (existingMapping.priority < priority) {
            [mappingsForObject insertObject:mapping atIndex:i];

            return;
        }
    }

    [mappingsForObject addObject:mapping];
}

- (NSMutableArray *)getMappingsForObject:(Class)object {
    NSString *key = NSStringFromClass(object);
    NSMutableArray *mappingsForObject = self.map[key];
    if (!mappingsForObject) {
        mappingsForObject = [[NSMutableArray alloc] init];
        self.map[key] = mappingsForObject;
    }

    return mappingsForObject;
}

- (void)executeCommand:(id)object {
    for (GCMapping *mapping in [[self getMappingsForObject:[object class]] copy]) {
        [self.injector map:object to:[object class]];
        if ([self allGuardsApprove:mapping.guards]) {
            [[self.injector getObject:mapping.commandClass] execute];
            if (mapping.remove)
                [self unMapCommand:mapping.commandClass fromObject:mapping.objectClass];
        }
        [self.injector unMap:object from:[object class]];
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