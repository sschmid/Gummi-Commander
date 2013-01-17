//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GCAsyncCommand.h"

@interface GCGIAsyncCommand : NSObject <GCAsyncCommand>
// strong by intention
@property(nonatomic, strong) id <GCAsyncCommandDelegate> delegate;

- (void)didExecuteWithSuccess:(BOOL)success;

@end