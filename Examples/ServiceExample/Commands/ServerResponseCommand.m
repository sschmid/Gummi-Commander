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
@synthesize event = _event;
@synthesize model = _model;


- (void)execute {
    self.model.lastServerResponse = self.event.response;
}

@end