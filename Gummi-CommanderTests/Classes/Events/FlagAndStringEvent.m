//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "FlagAndStringEvent.h"
#import "FlagAndStringObject.h"

@implementation FlagAndStringEvent

- (id)init {
    self = [super init];
    if (self) {
        self.object = [[FlagAndStringObject alloc] init];
    }

    return self;
}

@end