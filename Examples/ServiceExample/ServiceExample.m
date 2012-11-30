//
// Created by sschmid on 30.11.12.
//
// contact@sschmid.com
//


#import "ServiceExample.h"
#import "Objection.h"
#import "GummiModule.h"
#import "ServiceModule.h"
#import "Service.h"


@implementation ServiceExample

- (id)init {
    self = [super init];
    if (self) {

        // Init Gummi
        JSObjectionInjector *injector = [JSObjection createInjector];
        [JSObjection setDefaultInjector:injector];
        [injector addModule:[[GummiModule alloc] init]];

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
    [[JSObjection defaultInjector] removeModuleClass:[ServiceModule class]];
}

@end