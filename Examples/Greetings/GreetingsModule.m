//
// Created by sschmid on 27.11.12.
//
// contact@sschmid.com
//



#import "Objection.h"
#import "SDModule.h"
#import "GreetingsModule.h"
#import "GreetingEvent.h"
#import "GreetingCommand.h"

@implementation GreetingsModule

- (void)configure {
    [super configure];

    [self mapEventClass:[GreetingEvent class] toCommandClass:[GreetingCommand class]];
}

@end