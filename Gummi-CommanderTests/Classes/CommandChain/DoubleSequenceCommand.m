//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "DoubleSequenceCommand.h"
#import "Append12Async3AndSetFlagAsyncSequenceCommand.h"
#import "GIInjector.h"
#import "FlagAndStringObject.h"
#import "Append2AsyncCommand.h"
#import "FlagAndStringEvent.h"

@implementation DoubleSequenceCommand
inject(@"event")

- (id)init {
    self = [super init];
    if (self) {
        [self addCommand:[Append12Async3AndSetFlagAsyncSequenceCommand class]];
        [self addCommand:[Append2AsyncCommand class]];
        [self addCommand:[Append12Async3AndSetFlagAsyncSequenceCommand class]];
    }

    return self;
}

- (void)execute {
    self.injector = [self.injector createChildInjector];
    [self.injector map:self.event.object to:[self.event.object class]];
    [self.injector map:self.event to:[self.event class]];
    [super execute];
}

@end