//
// Created by sschmid on 20.11.12.
//
// contact@sschmid.com
//


@protocol SDCommandMap <NSObject>

- (void)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass;
- (void)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass priority:(int)priority;
- (void)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass removeMappingAfterExecution:(BOOL)remove;
- (void)mapEventClass:(Class)eventClass toCommandClass:(Class)commandClass priority:(int)priority removeMappingAfterExecution:(BOOL)remove;

- (void)unMapEventClass:(Class)eventClass fromCommandClass:(Class)commandClass;
- (void)unMapAll;
- (BOOL)isEventClass:(Class)eventClass mappedToCommandClass:(Class)commandClass;

@end