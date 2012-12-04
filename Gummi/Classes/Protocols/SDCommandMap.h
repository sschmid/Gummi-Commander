//
// Created by sschmid on 20.11.12.
//
// contact@sschmid.com
//


#import "SDEventCommandMapping.h"

@protocol SDCommandMap <NSObject>

- (SDEventCommandMapping *)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass;
- (SDEventCommandMapping *)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass priority:(int)priority;
- (SDEventCommandMapping *)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass removeMappingAfterExecution:(BOOL)remove;
- (SDEventCommandMapping *)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass priority:(int)priority removeMappingAfterExecution:(BOOL)remove;

- (SDEventCommandMapping *)mappingForEventClass:(Class)eventClass commandClass:(Class)commandClass;

- (void)unMapEventClass:(Class)eventClass fromCommandClass:(Class)commandClass;
- (void)unMapAll;

- (BOOL)isEventClass:(Class)eventClass mappedToCommandClass:(Class)commandClass;

@end