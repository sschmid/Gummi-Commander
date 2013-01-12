//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "SomeEvent.h"

@implementation SomeEvent

- (id)init {
    self = [super init];
    if (self) {
        self.string = [[NSString alloc] init];
    }

    return self;
}

@end