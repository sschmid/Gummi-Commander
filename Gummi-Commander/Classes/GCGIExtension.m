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

- (GCMapping *)mapCommand:(Class)commandClass toEvent:(Class)eventClass {
    return [self.commandMap mapCommand:commandClass toEvent:eventClass];
}

- (GCMapping *)mapCommand:(Class)commandClass toEvent:(Class)eventClass priority:(int)priority {
    return [self.commandMap mapCommand:commandClass toEvent:eventClass priority:priority];
}

- (GCMapping *)mapCommand:(Class)commandClass toEvent:(Class)eventClass removeMappingAfterExecution:(BOOL)remove {
    return [self.commandMap mapCommand:commandClass toEvent:eventClass removeMappingAfterExecution:remove];
}

- (GCMapping *)mapCommand:(Class)commandClass toEvent:(Class)eventClass priority:(int)priority removeMappingAfterExecution:(BOOL)remove {
    return [self.commandMap mapCommand:commandClass toEvent:eventClass priority:priority removeMappingAfterExecution:remove];
}

- (GCMapping *)mappingForCommand:(Class)commandClass event:(Class)eventClass {
    return [self.commandMap mappingForCommand:commandClass event:eventClass];
}

- (void)unMapCommand:(Class)commandClass fromEvent:(Class)eventClass {
    [self.commandMap unMapCommand:commandClass fromEvent:eventClass];
}

- (void)unMapAll {
    [self.commandMap unMapAll];
}

- (BOOL)isCommand:(Class)commandClass mappedToEvent:(Class)eventClass {
    return [self.commandMap isCommand:commandClass mappedToEvent:eventClass];
}

@end