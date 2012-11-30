//
// Created by sschmid on 27.11.12.
//
// contact@sschmid.com
//


#import "SDModule.h"

@interface SDModule ()
@property(nonatomic, strong) id <SDCommandMap> commandMap;
@end

@implementation SDModule
@synthesize commandMap = _commandMap;

- (void)configure {
    self.commandMap = [self.injector getObject:@protocol(SDCommandMap)];
}

- (void)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass {
    [self.commandMap mapEventClass:eventClass toCommandClass:commandClass];
}

- (void)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass priority:(int)priority {
    [self.commandMap mapEventClass:eventClass toCommandClass:commandClass priority:priority];
}

- (void)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass removeMappingAfterExecution:(BOOL)remove {
    [self.commandMap mapEventClass:eventClass toCommandClass:commandClass removeMappingAfterExecution:remove];
}

- (void)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass priority:(int)priority removeMappingAfterExecution:(BOOL)remove {
    [self.commandMap mapEventClass:eventClass toCommandClass:commandClass priority:priority removeMappingAfterExecution:remove];
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