//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GCMapping.h"

@protocol GCCommandMap <NSObject>

- (GCMapping *)mapEvent:(Class)event toCommand:(Class)command;
- (GCMapping *)mapEvent:(Class)event toCommand:(Class)command priority:(int)priority;
- (GCMapping *)mapEvent:(Class)event toCommand:(Class)command removeMappingAfterExecution:(BOOL)remove;
- (GCMapping *)mapEvent:(Class)event toCommand:(Class)command priority:(int)priority removeMappingAfterExecution:(BOOL)remove;

- (GCMapping *)mappingForEvent:(Class)event command:(Class)command;

- (void)unMapEvent:(Class)event fromCommand:(Class)command;
- (void)unMapAll;

- (BOOL)isEvent:(Class)event mappedToCommand:(Class)command;

@end