//
// Created by sschmid on 02.12.12.
//
// contact@sschmid.com
//


#import "ServerResponseGreater500Guard.h"
#import "Objection.h"


@implementation ServerResponseGreater500Guard
objection_requires(@"event")
@synthesize event = _event;


- (BOOL)approve {
    return [self.event.response intValue] > 500;
}

@end