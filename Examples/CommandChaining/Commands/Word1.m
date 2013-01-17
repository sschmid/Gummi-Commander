//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Word1.h"

@implementation Word1

- (void)execute {
    [self performSelector:@selector(logAWord:) withObject:@"This" afterDelay:1];
}

- (void)logAWord:(id)string {
    NSLog(@"%@", string);
    [self didExecuteWithSuccess:YES];
}

@end