//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GCAsyncCommand.h"

@protocol GCSequenceCommand <GCAsyncCommand>
@property(nonatomic) BOOL stopWhenNoSuccess;
- (void)addCommand:(Class)commandClass;
@end