//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Append12AndSetFlagSequenceCommand.h"
#import "SetFlagCommand.h"
#import "Append1Command.h"
#import "Append2Command.h"

@implementation Append12AndSetFlagSequenceCommand

- (id)init {
    self = [super init];
    if (self) {
        [self addCommand:[Append1Command class]];
        [self addCommand:[Append2Command class]];
        [self addCommand:[SetFlagCommand class]];
    }

    return self;
}

@end