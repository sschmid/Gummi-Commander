//
// Created by sschmid on 30.11.12.
//
// contact@sschmid.com
//


#import "ServerResponseEvent.h"


@implementation ServerResponseEvent

- (id)initWithResponse:(NSString *)response {
    self = [self initWithName:NSStringFromClass([self class])];
    self.response = response;

    return self;
}

+ (void)dispatchWithResponse:(NSString *)response {
    [[[self alloc] initWithResponse:response] dispatch];
}

@end