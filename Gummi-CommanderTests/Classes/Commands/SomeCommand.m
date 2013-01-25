//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "SomeCommand.h"
#import "GIInjector.h"
#import "SomeEvent.h"

@implementation SomeCommand
inject(@"event")

- (void)execute {
    self.event.string = @"some";
}

@end