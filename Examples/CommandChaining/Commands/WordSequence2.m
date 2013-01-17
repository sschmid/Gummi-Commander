//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "WordSequence2.h"
#import "Word5.h"
#import "Word6.h"

@implementation WordSequence2

- (id)init {
    self = [super init];
    if (self) {
        [self addCommand:[Word5 class]];
        [self addCommand:[Word6 class]];
    }

    return self;
}


@end