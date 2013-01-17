//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "CommandChainingExample.h"
#import "LogASentenceCommand.h"
#import "GIInjector.h"

@interface CommandChainingExample ()
@property(nonatomic, strong) id command;

@end

@implementation CommandChainingExample

- (id)init {
    self = [super init];
    if (self) {
        [[[GIInjector sharedInjector] getObject:[LogASentenceCommand class]] execute];
    }

    return self;
}


@end