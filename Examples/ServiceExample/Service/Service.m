//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Service.h"
#import "ServerResponseEvent.h"

@interface Service ()
@property(nonatomic, strong) NSTimer *timer;
@end

@implementation Service

- (id)init {
    self = [super init];
    if (self) {
        NSLog(@"Service init");
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(fakeServerChange) userInfo:nil repeats:YES];
    }

    return self;
}

- (void)fakeServerChange {
    [ServerResponseEvent dispatchWithResponse:[NSString stringWithFormat:@"%i", (arc4random() % 1000)]];
}

- (void)close {
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"Service closed.");
}

- (void)dealloc {
    NSLog(@"Service dealloc");
}

@end