//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "NoSuccessCommand.h"
#import "GIInjector.h"
#import "FlagAndStringObject.h"

@implementation NoSuccessCommand
inject(@"flagAndStringObject")

- (void)execute {
    [self performSelector:@selector(doSth) withObject:nil afterDelay:0.5];
}

- (void)doSth {
    self.flagAndStringObject.string = [self.flagAndStringObject.string stringByAppendingString:@"error"];
    [self.delegate command:self didExecuteWithSuccess:NO];
}

@end