//
//  AppDelegate.m
//  Gummi
//
//  Created by Simon Schmid on 29.11.12.
//  Copyright (c) 2012 Simon Schmid. All rights reserved.
//

#import "AppDelegate.h"
#import "GreetingsExample.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [[GreetingsExample alloc] init];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
