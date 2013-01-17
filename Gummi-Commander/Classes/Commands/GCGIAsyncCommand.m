//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GCGIAsyncCommand.h"

@implementation GCGIAsyncCommand

- (void)execute {
}

- (void)didExecuteWithSuccess:(BOOL)success {
    [self.delegate command:self didExecuteWithSuccess:success];
}

@end