//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Append3Command.h"
#import "GIInjector.h"
#import "FlagAndStringObject.h"

@implementation Append3Command
inject(@"flagAndStringObject")

- (void)execute {
    self.flagAndStringObject.string = [self.flagAndStringObject.string stringByAppendingString:@"3"];
}

@end