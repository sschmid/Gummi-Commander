//
// Created by sschmid on 27.11.12.
//
// contact@sschmid.com
//


#import "GreetingEvent.h"

@implementation GreetingEvent
@synthesize greeting = _greeting;

- (id)initWithGreeting:(NSString *)greeting {
    self = [self initWithName:NSStringFromClass([self class])];
    self.greeting = greeting;

    return self;
}

+ (void)greet:(NSString *)greeting {
    [[[self alloc] initWithGreeting:greeting] dispatch];
}

@end