//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "NoSuccessSequenceCommand.h"
#import "GIInjector.h"
#import "Append1AsyncCommand.h"
#import "FlagAndStringEvent.h"
#import "FlagAndStringObject.h"
#import "NoSuccessCommand.h"

@implementation NoSuccessSequenceCommand

inject(@"event")

- (id)init {
    self = [super init];
    if (self) {

        self.stopWhenNoSuccess = YES;

        [self addCommand:[NoSuccessCommand class]];
        [self addCommand:[Append1AsyncCommand class]];
    }

    return self;
}

- (void)execute {
    self.injector = [self.injector createChildInjector];
    [self.injector map:self.event.object to:[self.event.object class]];
    [super execute];
}

- (void)didExecuteWithSuccess:(BOOL)success {
    self.event.object.string = [self.event.object.string stringByAppendingString:@"NoSuccess"];
    [super didExecuteWithSuccess:success];
}

@end