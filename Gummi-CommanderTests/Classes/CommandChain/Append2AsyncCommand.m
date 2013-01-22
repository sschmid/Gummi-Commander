//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Append2AsyncCommand.h"
#import "GIInjector.h"
#import "FlagAndStringObject.h"

@implementation Append2AsyncCommand
inject(@"flagAndStringObject")

- (void)execute {
    [self performSelector:@selector(doSth) withObject:nil afterDelay:0.1];
}

- (void)doSth {
    self.flagAndStringObject.string = [self.flagAndStringObject.string stringByAppendingString:@"2_async"];
    [self.delegate command:self didExecuteWithSuccess:YES];
}

@end