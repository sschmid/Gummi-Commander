//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Append2Command.h"
#import "GIInjector.h"
#import "FlagAndStringObject.h"

@implementation Append2Command
inject(@"event")

- (void)execute {
    self.event.object.string = [self.event.object.string stringByAppendingString:@"2"];
}

@end