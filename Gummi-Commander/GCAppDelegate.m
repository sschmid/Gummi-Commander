//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "ServiceExample.h"
#import "GreetingsExample.h"
#import "GCAppDelegate.h"

@implementation GCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];

    [self addIcon];

    [[GreetingsExample alloc] init];

    [[ServiceExample alloc] init];

    return YES;
}

- (void)addIcon {
    UIImage *image = [UIImage imageNamed:@"Gummi-Commander-144.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGRect centerFrame = CGRectMake(self.window.center.x - imageView.frame.size.width / 2,
            self.window.center.y - imageView.frame.size.height / 2,
            imageView.frame.size.width,
            imageView.frame.size.height);

    imageView.frame = centerFrame;
    [self.window addSubview:imageView];
}

@end
