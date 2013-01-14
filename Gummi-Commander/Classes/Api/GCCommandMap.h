//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GCMapping.h"

@protocol GCCommandMap <NSObject>

- (GCMapping *)mapCommand:(Class)commandClass toObject:(Class)objectClass;
- (GCMapping *)mapCommand:(Class)commandClass toObject:(Class)objectClass priority:(int)priority;
- (GCMapping *)mapCommand:(Class)commandClass toObject:(Class)objectClass removeMappingAfterExecution:(BOOL)remove;
- (GCMapping *)mapCommand:(Class)commandClass toObject:(Class)objectClass priority:(int)priority removeMappingAfterExecution:(BOOL)remove;

- (GCMapping *)mappingForCommand:(Class)commandClass mappedToObject:(Class)objectClass;

- (void)unMapCommand:(Class)commandClass fromObject:(Class)objectClass;
- (void)unMapAll;

- (BOOL)isCommand:(Class)commandClass mappedToObject:(Class)objectClass;

@end