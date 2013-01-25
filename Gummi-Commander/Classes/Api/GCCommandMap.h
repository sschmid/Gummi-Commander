//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GCMapping.h"

@protocol GCCommandMap <NSObject>

- (GCMapping *)mapAction:(id)action toTrigger:(Class)trigger;
- (GCMapping *)mapAction:(id)action toTrigger:(Class)trigger priority:(int)priority;
- (GCMapping *)mapAction:(id)action toTrigger:(Class)trigger removeMappingAfterExecution:(BOOL)remove;
- (GCMapping *)mapAction:(id)action toTrigger:(Class)trigger priority:(int)priority removeMappingAfterExecution:(BOOL)remove;

- (GCMapping *)autoMapTrigger:(Class)trigger;

- (GCMapping *)mappingForAction:(id)action mappedToTrigger:(Class)trigger;

- (void)unMapAction:(id)action fromTrigger:(Class)trigger;
- (void)unMapAll;

- (BOOL)isAction:(id)action mappedToTrigger:(Class)trigger;

@end