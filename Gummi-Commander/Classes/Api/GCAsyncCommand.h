//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GCCommand.h"

@protocol GCAsyncCommand;

@protocol GCAsyncCommandDelegate
- (void)command:(id <GCAsyncCommand>)command didExecuteWithSuccess:(BOOL)success;
@end

@protocol GCAsyncCommand <GCCommand>
// strong by intention
@property(nonatomic, strong) id <GCAsyncCommandDelegate> delegate;
@end