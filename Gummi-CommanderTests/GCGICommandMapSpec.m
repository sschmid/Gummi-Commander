//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Kiwi.h"
#import "GIInjector.h"
#import "GCGICommandMap.h"
#import "GummiCommanderModule.h"
#import "FlagAndStringEvent.h"
#import "GCCommand.h"
#import "Append1Command.h"
#import "Append2Command.h"
#import "NoGuard.h"
#import "YesGuard.h"
#import "HasDependenciesSetGuard.h"
#import "GDDispatcher.h"
#import "FlagAndStringObject.h"
#import "SetFlagCommand.h"

SPEC_BEGIN(GCGICommandMapSpec)

        describe(@"GCGICommandMap", ^{

            __block GIInjector *injector = nil;
            __block GCGICommandMap *commandMap = nil;
            beforeEach(^{
                [[GIInjector sharedInjector] reset];
                injector = [GIInjector sharedInjector];
                [injector addModule:[[GummiCommanderModule alloc] init]];
                commandMap = [injector getObject:@protocol(GCCommandMap)];
            });

            it(@"instantiates commandMap", ^{
                [[commandMap should] beKindOfClass:[GCGICommandMap class]];
            });

            it(@"has dispatcher", ^{
                id dispatcher = commandMap.dispatcher;
                [[dispatcher should] beKindOfClass:[GDDispatcher class]];
            });

            it(@"has no mapping", ^{
                BOOL has = [commandMap isAction:[Append1Command class] mappedToTrigger:[FlagAndStringEvent class]];

                [[theValue(has) should] beNo];
            });

            context(@"when command mapping added", ^{

                beforeEach(^{
                    [commandMap mapAction:[Append1Command class] toTrigger:[FlagAndStringEvent class]];
                });

                it(@"has a mapping", ^{
                    BOOL has = [commandMap isAction:[Append1Command class] mappedToTrigger:[FlagAndStringEvent class]];
                    [[theValue(has) should] beYes];

                });

                it(@"removes mapping", ^{
                    [commandMap unMapAction:[Append1Command class] fromTrigger:[FlagAndStringEvent class]];
                    BOOL has = [commandMap isAction:[Append1Command class] mappedToTrigger:[FlagAndStringEvent class]];
                    [[theValue(has) should] beNo];
                });

                it(@"removes all mappings", ^{
                    [commandMap mapAction:[Append2Command class] toTrigger:[FlagAndStringEvent class]];
                    [commandMap unMapAll];

                    BOOL has1 = [commandMap isAction:[Append1Command class] mappedToTrigger:[FlagAndStringEvent class]];
                    BOOL has2 = [commandMap isAction:[Append2Command class] mappedToTrigger:[FlagAndStringEvent class]];

                    [[theValue(has1) should] beNo];
                    [[theValue(has2) should] beNo];
                });

            });

            context(@"when block mapping added", ^{

                __block void (^myBlock)(GIInjector *inj);
                beforeEach(^{
                    myBlock = ^(GIInjector *inj) {
                        FlagAndStringEvent *event = [inj getObject:[FlagAndStringEvent class]];
                        event.object.flag = YES;
                        event.object.string = @"block";
                    };

                    [commandMap mapAction:myBlock toTrigger:[FlagAndStringEvent class]];
                });

                it(@"has a mapping", ^{
                    BOOL has = [commandMap isAction:myBlock mappedToTrigger:[FlagAndStringEvent class]];
                    [[theValue(has) should] beYes];
                });

                it(@"executes block", ^{
                    FlagAndStringEvent *event = [[FlagAndStringEvent alloc] init];
                    [commandMap.dispatcher dispatchObject:event];

                    [[theValue(event.object.flag) should] beYes];
                    [[event.object.string should] equal:@"block"];
                });

                it(@"removes mapping", ^{
                    [commandMap unMapAction:myBlock fromTrigger:[FlagAndStringEvent class]];
                    BOOL has = [commandMap isAction:myBlock mappedToTrigger:[FlagAndStringEvent class]];
                    [[theValue(has) should] beNo];
                });

                it(@"removes all mappings", ^{
                    [commandMap mapAction:[Append2Command class] toTrigger:[FlagAndStringEvent class]];
                    [commandMap unMapAll];

                    BOOL has1 = [commandMap isAction:myBlock mappedToTrigger:[FlagAndStringEvent class]];
                    BOOL has2 = [commandMap isAction:[Append2Command class] mappedToTrigger:[FlagAndStringEvent class]];

                    [[theValue(has1) should] beNo];
                    [[theValue(has2) should] beNo];
                });

            });

            context(@"when dispatch event", ^{

                __block FlagAndStringEvent *event;
                beforeEach(^{
                    event = [[FlagAndStringEvent alloc] init];
                });

                it(@"executes a command", ^{
                    [commandMap mapAction:[SetFlagCommand class] toTrigger:[event class]];
                    [event dispatch];

                    [[theValue(event.object.flag) should] beYes];
                });

                it(@"executes commands in right order", ^{
                    [commandMap mapAction:[Append1Command class] toTrigger:[FlagAndStringEvent class]];
                    [commandMap mapAction:[Append2Command class] toTrigger:[FlagAndStringEvent class]];
                    [event dispatch];

                    [[event.object.string should] equal:@"12"];
                });

                it(@"executes commands in right order", ^{
                    [commandMap mapAction:[Append2Command class] toTrigger:[FlagAndStringEvent class]];
                    [commandMap mapAction:[Append1Command class] toTrigger:[FlagAndStringEvent class]];
                    [event dispatch];

                    [[event.object.string should] equal:@"21"];
                });

                it(@"executes commands in right order", ^{
                    [commandMap mapAction:[Append1Command class] toTrigger:[FlagAndStringEvent class] priority:10];
                    [commandMap mapAction:[Append2Command class] toTrigger:[FlagAndStringEvent class] priority:20];
                    [event dispatch];

                    [[event.object.string should] equal:@"21"];
                });

                it(@"executes commands in right order", ^{
                    [commandMap mapAction:[Append2Command class] toTrigger:[FlagAndStringEvent class] priority:20];
                    [commandMap mapAction:[Append1Command class] toTrigger:[FlagAndStringEvent class] priority:10];
                    [event dispatch];

                    [[event.object.string should] equal:@"21"];
                });

                it(@"auto removes mapping", ^{
                    [commandMap mapAction:[Append1Command class] toTrigger:[FlagAndStringEvent class] priority:10 removeMappingAfterExecution:YES];

                    [commandMap.dispatcher dispatchObject:event];
                    [commandMap.dispatcher dispatchObject:event];

                    [[event.object.string should] equal:@"1"];
                });

            });

            context(@"guards", ^{

                it(@"has no mapping", ^{
                    GCMapping *mapping = [commandMap mappingForAction:[Append1Command class] mappedToTrigger:[FlagAndStringEvent class]];

                    [mapping shouldBeNil];
                });

                context(@"when added a mapping", ^{

                    beforeEach(^{
                        [commandMap mapAction:[Append1Command class] toTrigger:[FlagAndStringEvent class]];
                    });

                    it(@"has mapping", ^{
                        GCMapping *mapping = [commandMap mappingForAction:[Append1Command class] mappedToTrigger:[FlagAndStringEvent class]];

                        [[mapping should] beKindOfClass:[GCMapping class]];
                    });

                    it(@"has no guards", ^{
                        GCMapping *mapping = [commandMap mappingForAction:[Append1Command class] mappedToTrigger:[FlagAndStringEvent class]];
                        BOOL has = [mapping hasGuard:[YesGuard class]];

                        [[theValue(has) should] beNo];
                    });

                    context(@"when guards added", ^{

                        __block NSArray *guards = nil;
                        __block GCMapping *mapping = nil;
                        beforeEach(^{
                            mapping = [commandMap mappingForAction:[Append1Command class] mappedToTrigger:[FlagAndStringEvent class]];
                        });

                        it(@"has guard", ^{
                            guards = @[[YesGuard class]];
                            [mapping withGuards:guards];
                            BOOL has = [mapping hasGuard:[YesGuard class]];

                            [[theValue(has) should] beYes];
                        });

                        it(@"prevents command execution when guard does not approve", ^{
                            [mapping withGuards:@[[NoGuard class]]];
                            FlagAndStringEvent *event = [[FlagAndStringEvent alloc] init];
                            [event dispatch];

                            [[event.object.string should] equal:@""];
                        });

                        it(@"executes command when guard approves", ^{
                            [mapping withGuards:@[[YesGuard class]]];
                            FlagAndStringEvent *event = [[FlagAndStringEvent alloc] init];
                            [event dispatch];

                            [[event.object.string should] equal:@"1"];
                        });

                        it(@"injects dependencies into guards", ^{
                            [mapping withGuards:@[[HasDependenciesSetGuard class]]];
                            FlagAndStringEvent *event = [[FlagAndStringEvent alloc] init];
                            [event dispatch];

                            [[event.object.string should] equal:@"1"];
                        });

                    });

                });

            });

        });

        SPEC_END