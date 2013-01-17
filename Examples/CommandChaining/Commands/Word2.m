//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Word2.h"

@implementation Word2

- (void)execute {
    [self performSelector:@selector(logAWord:) withObject:@"is" afterDelay:1];
}

- (void)logAWord:(id)string {
    NSLog(@"%@", string);
    [self didExecuteWithSuccess:YES];
}

@end