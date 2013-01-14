//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GCGIExtension.h"
#import "GIInjector.h"

@interface GCGIExtension ()
@property(nonatomic, strong) id <GCCommandMap> commandMap;
@end

@implementation GCGIExtension

- (void)configure:(GIInjector *)injector {
    [super configure:injector];
    self.commandMap = [_injector getObject:@protocol(GCCommandMap)];
}

- (void)unload {
    [self unMapAll];
    self.commandMap = nil;
    [super unload];
}

- (GCMapping *)mapCommand:(Class)commandClass toObject:(Class)objectClass {
    return [self.commandMap mapCommand:commandClass toObject:objectClass];
}

- (GCMapping *)mapCommand:(Class)commandClass toObject:(Class)objectClass priority:(int)priority {
    return [self.commandMap mapCommand:commandClass toObject:objectClass priority:priority];
}

- (GCMapping *)mapCommand:(Class)commandClass toObject:(Class)objectClass removeMappingAfterExecution:(BOOL)remove {
    return [self.commandMap mapCommand:commandClass toObject:objectClass removeMappingAfterExecution:remove];
}

- (GCMapping *)mapCommand:(Class)commandClass toObject:(Class)objectClass priority:(int)priority removeMappingAfterExecution:(BOOL)remove {
    return [self.commandMap mapCommand:commandClass toObject:objectClass priority:priority removeMappingAfterExecution:remove];
}

- (GCMapping *)mappingForCommand:(Class)commandClass mappedToObject:(Class)objectClass {
    return [self.commandMap mappingForCommand:commandClass mappedToObject:objectClass];
}

- (void)unMapCommand:(Class)commandClass fromObject:(Class)objectClass {
    [self.commandMap unMapCommand:commandClass fromObject:objectClass];
}

- (void)unMapAll {
    [self.commandMap unMapAll];
}

- (BOOL)isCommand:(Class)commandClass mappedToObject:(Class)objectClass {
    return [self.commandMap isCommand:commandClass mappedToObject:objectClass];
}

@end