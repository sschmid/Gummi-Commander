//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Word6.h"

@implementation Word6

- (void)execute {
    [self performSelector:@selector(logAWord:) withObject:@"good!" afterDelay:1];
}

- (void)logAWord:(id)string {
    NSLog(@"%@", string);
    [self didExecuteWithSuccess:YES];
}

@end