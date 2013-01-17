//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "FlagAndStringObject.h"

@implementation FlagAndStringObject

- (id)init {
    self = [super init];
    if (self) {
        self.flag = NO;
        self.string = @"";
    }

    return self;
}

@end