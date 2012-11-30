//
// Created by sschmid on 30.11.12.
//
// contact@sschmid.com
//


#import "ServerResponseCommand.h"
#import "ServerResponseEvent.h"
#import "Objection.h"
#import "Model.h"


@implementation ServerResponseCommand
objection_requires(@"event", @"model")
@synthesize event = _event;
@synthesize model = _model;


- (void)execute {
    self.model.lastServerResponse = self.event.response;
}

@end