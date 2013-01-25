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

- (void)configure:(GIInjector *)injector {
    [super configure:injector];
    self.commandMap = [_injector getObject:@protocol(GCCommandMap)];
}

- (void)unload {
    [self unMapAll];
    self.commandMap = nil;
    [super unload];
}

- (GCMapping *)mapAction:(id)action toTrigger:(Class)trigger {
    return [self.commandMap mapAction:action toTrigger:trigger];
}

- (GCMapping *)mapAction:(id)action toTrigger:(Class)trigger priority:(int)priority {
    return [self.commandMap mapAction:action toTrigger:trigger priority:priority];
}

- (GCMapping *)mapAction:(id)action toTrigger:(Class)trigger removeMappingAfterExecution:(BOOL)remove {
    return [self.commandMap mapAction:action toTrigger:trigger removeMappingAfterExecution:remove];
}

- (GCMapping *)mapAction:(id)action toTrigger:(Class)trigger priority:(int)priority removeMappingAfterExecution:(BOOL)remove {
    return [self.commandMap mapAction:action toTrigger:trigger priority:priority removeMappingAfterExecution:remove];
}

- (GCMapping *)autoMapTrigger:(Class)trigger {
    return [self.commandMap autoMapTrigger:trigger];
}

- (GCMapping *)mappingForAction:(id)action mappedToTrigger:(Class)trigger {
    return [self.commandMap mappingForAction:action mappedToTrigger:trigger];
}

- (void)unMapAction:(id)action fromTrigger:(Class)trigger {
    [self.commandMap unMapAction:action fromTrigger:trigger];
}

- (void)unMapAll {
    [self.commandMap unMapAll];
}

- (BOOL)isAction:(id)action mappedToTrigger:(Class)trigger {
    return [self.commandMap isAction:action mappedToTrigger:trigger];
}

@end