//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GCGIExtension.h"
#import "GIInjector.h"

@interface GCGIExtension ()
@property(nonatomic, strong) id <GCCommandMap> commandMap;
@end

@implementation GCGIExtension
@synthesize commandMap = _commandMap;

- (void)configure:(GIInjector *)injector {
    [super configure:injector];
    self.commandMap = [_injector getObject:@protocol(GCCommandMap)];
}

- (void)unload {
    [self unMapAll];
    self.commandMap = nil;
    [super unload];
}

- (GCMapping *)mapEvent:(Class)event toCommand:(Class)command {
    return [self.commandMap mapEvent:event toCommand:command];
}

- (GCMapping *)mapEvent:(Class)event toCommand:(Class)command priority:(int)priority {
    return [self.commandMap mapEvent:event toCommand:command priority:priority];
}

- (GCMapping *)mapEvent:(Class)event toCommand:(Class)command removeMappingAfterExecution:(BOOL)remove {
    return [self.commandMap mapEvent:event toCommand:command removeMappingAfterExecution:remove];
}

- (GCMapping *)mapEvent:(Class)event toCommand:(Class)command priority:(int)priority removeMappingAfterExecution:(BOOL)remove {
    return [self.commandMap mapEvent:event toCommand:command priority:priority removeMappingAfterExecution:remove];
}

- (GCMapping *)mappingForEvent:(Class)event command:(Class)command {
    return [self.commandMap mappingForEvent:event command:command];
}

- (void)unMapEvent:(Class)event fromCommand:(Class)command {
    [self.commandMap unMapEvent:event fromCommand:command];
}

- (void)unMapAll {
    [self.commandMap unMapAll];
}

- (BOOL)isEvent:(Class)event mappedToCommand:(Class)command {
    return [self.commandMap isEvent:event mappedToCommand:command];
}

@end