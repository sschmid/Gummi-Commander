//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "ServiceExample.h"
#import "ServiceModule.h"
#import "GIInjector.h"
#import "GummiCommander.h"


@implementation ServiceExample

- (id)init {
    self = [super init];
    if (self) {

        // Init Gummi
        GIInjector *injector = [GIInjector sharedInjector];
        [injector addModule:[[GummiCommander alloc] init]];

        // Plug in example
        NSLog(@"Adding ServiceModule module");
        [injector addModule:[[ServiceModule alloc] init]];

        // Remove ServiceModule after 5 seconds
        [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(remove) userInfo:nil repeats:NO];
    }

    return self;
}

- (void)remove {
    NSLog(@"Remove ServiceModule");
    [[GIInjector sharedInjector] removeModuleClass:[ServiceModule class]];

    [[GIInjector sharedInjector] reset];
}

@end