//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "ServerResponseEvent.h"


@implementation ServerResponseEvent

- (id)initWithResponse:(NSString *)response {
    self = [self init];
    self.response = response;

    return self;
}

+ (void)dispatchWithResponse:(NSString *)response {
    [[[self alloc] initWithResponse:response] dispatch];
}

@end