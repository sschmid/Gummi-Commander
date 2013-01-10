//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "ServiceExample.h"
#import "ServiceModule.h"
#import "GIInjector.h"
#import "GummiCommanderModule.h"


@implementation ServiceExample

- (id)init {
    self = [super init];
    if (self) {

        // Init Gummi Commander
        GIInjector *injector = [GIInjector sharedInjector];
        [injector addModule:[[GummiCommanderModule alloc] init]];

        // Plug in example
        NSLog(@"Adding ServiceModule");
        [injector addModule:[[ServiceModule alloc] init]];

        // Remove ServiceModule after 5 seconds
        [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(remove) userInfo:nil repeats:NO];
    }

    return self;
}

- (void)remove {
    NSLog(@"Remove ServiceModule");
    [[GIInjector sharedInjector] removeModuleClass:[ServiceModule class]];
}

@end