//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>

@interface GCMapping : NSObject
@property(nonatomic, readonly, strong) Class commandClass;
@property(nonatomic, readonly, strong) Class objectClass;
@property(nonatomic, readonly) int priority;
@property(nonatomic, readonly) BOOL remove;
@property(nonatomic, readonly, strong) NSArray *guards;

- (id)initWithCommand:(Class)commandClass object:(Class)objectClass priority:(int)priority remove:(BOOL)remove;

- (void)withGuards:(NSArray *)guards;
- (BOOL)hasGuard:(Class)guardClass;

@end
