//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "ServiceExample.h"
#import "GreetingsExample.h"
#import "GCAppDelegate.h"

@implementation GCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [[GreetingsExample alloc] init];
    [[ServiceExample alloc] init];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
