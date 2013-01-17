//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Word3.h"

@implementation Word3

- (void)execute {
    [self performSelector:@selector(logAWord:) withObject:@"actually" afterDelay:1];
}

- (void)logAWord:(id)string {
    NSLog(@"%@", string);
    [self didExecuteWithSuccess:YES];
}

@end