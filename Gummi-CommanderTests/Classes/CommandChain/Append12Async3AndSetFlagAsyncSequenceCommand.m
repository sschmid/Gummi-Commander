//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Append12Async3AndSetFlagAsyncSequenceCommand.h"
#import "Append1AsyncCommand.h"
#import "Append2AsyncCommand.h"
#import "SetFlagCommand.h"
#import "Append3Command.h"
#import "GIInjector.h"
#import "FlagAndStringEvent.h"
#import "FlagAndStringObject.h"

@implementation Append12Async3AndSetFlagAsyncSequenceCommand
inject(@"event")

- (id)init {
    self = [super init];
    if (self) {
        [self addCommand:[Append1AsyncCommand class]];
        [self addCommand:[Append2AsyncCommand class]];
        [self addCommand:[Append3Command class]];
        [self addCommand:[SetFlagCommand class]];
    }

    return self;
}

- (void)execute {
    self.injector = [self.injector createChildInjector];
    [self.injector map:self.event.object to:[self.event.object class]];
    [super execute];
}

@end