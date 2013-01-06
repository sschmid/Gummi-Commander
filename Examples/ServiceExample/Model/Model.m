//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "Model.h"


@implementation Model
@synthesize lastServerResponse = _lastServerResponse;

- (id)init {
    self = [super init];
    if (self) {
        NSLog(@"Model init");
    }

    return self;
}

- (void)setLastServerResponse:(NSString *)lastServerResponse {
    _lastServerResponse = lastServerResponse;
    NSLog(@"Server has some changes for me: %@", _lastServerResponse);
}

- (void)dealloc {
    NSLog(@"Model dealloc");
}

@end