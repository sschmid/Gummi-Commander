//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>

@interface GCMapping : NSObject
@property(nonatomic, readonly) id action;
@property(nonatomic, readonly, strong) Class trigger;
@property(nonatomic, readonly) int priority;
@property(nonatomic, readonly) BOOL remove;
@property(nonatomic, readonly, strong) NSArray *guards;

- (id)initWithAction:(id)action trigger:(Class)trigger priority:(int)priority remove:(BOOL)remove;

- (void)withGuards:(NSArray *)guards;
- (BOOL)hasGuard:(Class)guardClass;

@end
