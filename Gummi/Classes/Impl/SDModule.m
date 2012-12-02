//
// Created by sschmid on 27.11.12.
//
// contact@sschmid.com
//


#import "SDModule.h"
#import "SDEventCommandMapping.h"

@interface SDModule ()
@property(nonatomic, strong) id <SDCommandMap> commandMap;
@end

@implementation SDModule
@synthesize commandMap = _commandMap;

- (void)configure {
    self.commandMap = [self.injector getObject:@protocol(SDCommandMap)];
}

- (SDEventCommandMapping *)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass {
    return [self.commandMap mapEventClass:eventClass toCommandClass:commandClass];
}

- (SDEventCommandMapping *)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass priority:(int)priority {
    return [self.commandMap mapEventClass:eventClass toCommandClass:commandClass priority:priority];
}

- (SDEventCommandMapping *)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass removeMappingAfterExecution:(BOOL)remove {
    return [self.commandMap mapEventClass:eventClass toCommandClass:commandClass removeMappingAfterExecution:remove];
}

- (SDEventCommandMapping *)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass priority:(int)priority removeMappingAfterExecution:(BOOL)remove {
    return [self.commandMap mapEventClass:eventClass toCommandClass:commandClass priority:priority removeMappingAfterExecution:remove];
}

- (SDEventCommandMapping *)mappingForEventClass:(Class)eventClass commandClass:(Class)commandClass {
    return [self.commandMap mappingForEventClass:eventClass commandClass:commandClass];
}

- (void)unMapEventClass:(Class)eventClass fromCommandClass:(Class)commandClass {
    [self.commandMap unMapEventClass:eventClass fromCommandClass:commandClass];
}

- (void)unMapAll {
    [self.commandMap unMapAll];
}

- (BOOL)isEventClass:(Class)eventClass mappedToCommandClass:(Class)commandClass {
    return [self.commandMap isEventClass:eventClass mappedToCommandClass:commandClass];
}

- (void)unload {
    [self unMapAll];
    self.commandMap = nil;
}

@end