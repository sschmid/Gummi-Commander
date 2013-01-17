//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Word5.h"

@implementation Word5

- (void)execute {
    [self performSelector:@selector(logAWord:) withObject:@"pretty" afterDelay:1];
}

- (void)logAWord:(id)string {
    NSLog(@"%@", string);
    [self didExecuteWithSuccess:YES];
}

@end