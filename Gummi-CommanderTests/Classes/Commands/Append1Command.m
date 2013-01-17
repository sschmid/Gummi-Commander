//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GCCommand.h"
#import "Append1Command.h"
#import "GIInjector.h"
#import "FlagAndStringEvent.h"
#import "FlagAndStringObject.h"


@implementation Append1Command
inject(@"event");

- (void)execute {
    self.event.object.string = [self.event.object.string stringByAppendingString:@"1"];
}

@end