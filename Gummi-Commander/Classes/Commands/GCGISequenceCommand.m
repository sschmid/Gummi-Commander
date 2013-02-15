//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GCGISequenceCommand.h"
#import "GIInjector.h"

@interface GCGISequenceCommand ()
@property(nonatomic, strong) NSMutableArray *commands;
@property(nonatomic) uint commandIndex;
@property(nonatomic, strong) id <GCAsyncCommand> detainedCommand;
@end

@implementation GCGISequenceCommand
inject(@"injector")

- (id)init {
    self = [super init];
    if (self) {
        self.commands = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)addCommand:(Class)commandClass {
    [self.commands addObject:commandClass];
}

- (void)execute {
    self.commandIndex = 0;
    [self executeNextCommand];
}

- (void)executeNextCommand {
    if (self.commandIndex < self.commands.count) {
        Class commandClass = self.commands[self.commandIndex++];
        if ([self isAsyncCommand:commandClass]) {
            id <GCAsyncCommand> asyncCommand = [self.injector getObject:commandClass];
            asyncCommand.delegate = self;
            [asyncCommand execute];
        } else {
            [[self.injector getObject:commandClass] execute];
            [self executeNextCommand];
        }
    } else {
        [self didExecuteWithSuccess:YES];
    }
}

- (BOOL)isAsyncCommand:(Class)commandClass {
    return [commandClass conformsToProtocol:@protocol(GCAsyncCommand)] || [commandClass conformsToProtocol:@protocol(GCSequenceCommand)];
}

- (void)command:(id <GCAsyncCommand>)command didExecuteWithSuccess:(BOOL)success {
    command.delegate = nil;
    if (self.stopWhenNoSuccess && !success) {
        NSLog(@"'%@' did execute without success", NSStringFromClass([command class]));
        NSLog(@"Cancelling Sequence '%@'", NSStringFromClass([self class]));
        [self didExecuteWithSuccess:NO];
    } else {
        [self executeNextCommand];
    }
}

@end