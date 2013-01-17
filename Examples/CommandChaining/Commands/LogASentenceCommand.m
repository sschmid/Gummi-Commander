//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "LogASentenceCommand.h"
#import "Headline.h"
#import "Word1.h"
#import "WordSequence1.h"

@implementation LogASentenceCommand

- (id)init {
    self = [super init];
    if (self) {

        self.stopWhenNoSuccess = NO; // Default

        [self addCommand:[Headline class]];
        [self addCommand:[Word1 class]];
        [self addCommand:[WordSequence1 class]];
    }

    return self;
}

@end