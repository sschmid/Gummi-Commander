//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "ServerResponseCommand.h"
#import "ServerResponseEvent.h"
#import "Model.h"
#import "GIInjector.h"

@implementation ServerResponseCommand
inject(@"event", @"model")

- (void)execute {
    self.model.lastServerResponse = self.event.response;
}

@end