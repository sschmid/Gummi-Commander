//
// Created by sschmid on 22.11.12.
//
// contact@sschmid.com
//


#import "SomeEvent.h"
#import "SomeObject.h"

@implementation SomeEvent
@synthesize string = _string;
@synthesize object = _object;

- (id)init {
    self = [super init];
    if (self) {
        self.string = [[NSString alloc] init];
    }

    return self;
}


@end