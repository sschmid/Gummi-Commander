//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "SomeObserver.h"
#import "SomeEvent.h"


@implementation SomeObserver

- (id)init {
    self = [super init];
    if (self) {
        self.result = @"";
    }

    return self;
}

- (void)m1:(SomeEvent *)event {
    self.result = [self.result stringByAppendingString:@"1"];
}
- (void)m2:(SomeEvent *)event {
    self.result = [self.result stringByAppendingString:@"2"];
}
- (void)m3:(SomeEvent *)event {
    self.result = [self.result stringByAppendingString:@"3"];
}
- (void)m4:(SomeEvent *)event {
    self.result = [self.result stringByAppendingString:@"4"];
}
- (void)m5:(SomeEvent *)event {
    self.result = [self.result stringByAppendingString:@"5"];
}

@end