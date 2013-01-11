//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GCMapping.h"

@protocol GCCommandMap <NSObject>

- (GCMapping *)mapCommand:(Class)commandClass toEvent:(Class)eventClass;
- (GCMapping *)mapCommand:(Class)commandClass toEvent:(Class)eventClass priority:(int)priority;
- (GCMapping *)mapCommand:(Class)commandClass toEvent:(Class)eventClass removeMappingAfterExecution:(BOOL)remove;
- (GCMapping *)mapCommand:(Class)commandClass toEvent:(Class)eventClass priority:(int)priority removeMappingAfterExecution:(BOOL)remove;

- (GCMapping *)mappingForCommand:(Class)commandClass event:(Class)eventClass;

- (void)unMapCommand:(Class)commandClass fromEvent:(Class)eventClass;
- (void)unMapAll;

- (BOOL)isCommand:(Class)commandClass mappedToEvent:(Class)eventClass;

@end