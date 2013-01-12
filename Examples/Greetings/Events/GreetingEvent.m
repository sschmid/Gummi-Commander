//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GreetingEvent.h"

@implementation GreetingEvent

- (id)initWithGreeting:(NSString *)greeting {
    self = [self init];
    self.greeting = greeting;

    return self;
}

+ (void)greet:(NSString *)greeting {
    [[[self alloc] initWithGreeting:greeting] dispatch];
}

@end