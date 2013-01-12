//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>

@interface GCMapping : NSObject
@property(nonatomic, readonly, strong) Class eventClass;
@property(nonatomic, readonly, strong) Class commandClass;
@property(nonatomic, readonly) int priority;
@property(nonatomic, readonly) BOOL remove;
@property(nonatomic, readonly, strong) NSArray *guards;

- (id)initWithEvent:(Class)eventClass command:(Class)commandClass priority:(int)priority remove:(BOOL)remove;

- (void)withGuards:(NSArray *)guards;
- (BOOL)hasGuard:(Class)guardClass;

@end
