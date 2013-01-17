//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Append1AsyncCommand.h"
#import "GIInjector.h"
#import "FlagAndStringObject.h"

@implementation Append1AsyncCommand
inject(@"flagAndStringObject")

- (void)execute {
    [self performSelector:@selector(doSth) withObject:nil afterDelay:1];
}

- (void)doSth {
    self.flagAndStringObject.string = [self.flagAndStringObject.string stringByAppendingString:@"1_async"];
    [self.delegate command:self didExecuteWithSuccess:YES];
}

@end