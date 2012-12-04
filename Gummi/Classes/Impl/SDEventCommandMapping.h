//
// Created by sschmid on 30.11.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>


@interface SDEventCommandMapping : NSObject
@property(nonatomic, readonly, strong) Class eventClass;
@property(nonatomic, readonly, strong) Class commandClass;
@property(nonatomic, readonly) int priority;
@property(nonatomic, readonly) BOOL remove;
@property(nonatomic, readonly, strong) NSArray *guards;

- (id)initWithEventClass:(Class)eventClass commandClass:(Class)commandClass priority:(int)priority remove:(BOOL)remove;

- (void)withGuards:(NSArray *)guards;
- (BOOL)hasGuard:(Class)guardClass;

@end
