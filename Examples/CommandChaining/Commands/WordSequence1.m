//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "WordSequence1.h"
#import "Word2.h"
#import "Word3.h"
#import "Word4.h"
#import "WordSequence2.h"

@implementation WordSequence1

- (id)init {
    self = [super init];
    if (self) {
        [self addCommand:[Word2 class]];
        [self addCommand:[Word3 class]];
        [self addCommand:[Word4 class]];
        [self addCommand:[WordSequence2 class]];
    }

    return self;
}


@end