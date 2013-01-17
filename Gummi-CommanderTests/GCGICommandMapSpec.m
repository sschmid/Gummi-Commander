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
                BOOL has = [commandMap isCommand:[Append1Command class] mappedToObject:[FlagAndStringEvent class]];

                [[theValue(has) should] beNo];
            });

            context(@"when mapping added", ^{

                beforeEach(^{
                    [commandMap mapCommand:[Append1Command class] toObject:[FlagAndStringEvent class]];
                });

                it(@"has a mapping", ^{
                    BOOL has = [commandMap isCommand:[Append1Command class] mappedToObject:[FlagAndStringEvent class]];
                    [[theValue(has) should] beYes];

                });

                it(@"removes mapping", ^{
                    [commandMap unMapCommand:[Append1Command class] fromObject:[FlagAndStringEvent class]];
                    BOOL has = [commandMap isCommand:[Append1Command class] mappedToObject:[FlagAndStringEvent class]];
                    [[theValue(has) should] beNo];
                });

                it(@"removes all mappings", ^{
                    [commandMap mapCommand:[Append2Command class] toObject:[FlagAndStringEvent class]];
                    [commandMap unMapAll];

                    BOOL has1 = [commandMap isCommand:[Append1Command class] mappedToObject:[FlagAndStringEvent class]];
                    BOOL has2 = [commandMap isCommand:[Append2Command class] mappedToObject:[FlagAndStringEvent class]];

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
                    [commandMap mapCommand:[SetFlagCommand class] toObject:[event class]];
                    [event dispatch];

                    [[theValue(event.object.flag) should] beYes];
                });

                it(@"executes commands in right order", ^{
                    [commandMap mapCommand:[Append1Command class] toObject:[FlagAndStringEvent class]];
                    [commandMap mapCommand:[Append2Command class] toObject:[FlagAndStringEvent class]];
                    [event dispatch];

                    [[event.object.string should] equal:@"12"];
                });

                it(@"executes commands in right order", ^{
                    [commandMap mapCommand:[Append2Command class] toObject:[FlagAndStringEvent class]];
                    [commandMap mapCommand:[Append1Command class] toObject:[FlagAndStringEvent class]];
                    [event dispatch];

                    [[event.object.string should] equal:@"21"];
                });

                it(@"executes commands in right order", ^{
                    [commandMap mapCommand:[Append1Command class] toObject:[FlagAndStringEvent class] priority:10];
                    [commandMap mapCommand:[Append2Command class] toObject:[FlagAndStringEvent class] priority:20];
                    [event dispatch];

                    [[event.object.string should] equal:@"21"];
                });

                it(@"executes commands in right order", ^{
                    [commandMap mapCommand:[Append2Command class] toObject:[FlagAndStringEvent class] priority:20];
                    [commandMap mapCommand:[Append1Command class] toObject:[FlagAndStringEvent class] priority:10];
                    [event dispatch];

                    [[event.object.string should] equal:@"21"];
                });

                it(@"auto removes mapping", ^{
                    [commandMap mapCommand:[Append1Command class] toObject:[FlagAndStringEvent class] priority:10 removeMappingAfterExecution:YES];

                    [commandMap.dispatcher dispatchObject:event];
                    [commandMap.dispatcher dispatchObject:event];

                    [[event.object.string should] equal:@"1"];
                });

            });

            context(@"guards", ^{

                it(@"has no mapping", ^{
                    GCMapping *mapping = [commandMap mappingForCommand:[Append1Command class] mappedToObject:[FlagAndStringEvent class]];

                    [mapping shouldBeNil];
                });

                context(@"when added a mapping", ^{

                    beforeEach(^{
                        [commandMap mapCommand:[Append1Command class] toObject:[FlagAndStringEvent class]];
                    });

                    it(@"has mapping", ^{
                        GCMapping *mapping = [commandMap mappingForCommand:[Append1Command class] mappedToObject:[FlagAndStringEvent class]];

                        [[mapping should] beKindOfClass:[GCMapping class]];
                    });

                    it(@"has no guards", ^{
                        GCMapping *mapping = [commandMap mappingForCommand:[Append1Command class] mappedToObject:[FlagAndStringEvent class]];
                        BOOL has = [mapping hasGuard:[YesGuard class]];

                        [[theValue(has) should] beNo];
                    });

                    context(@"when guards added", ^{

                        __block NSArray *guards = nil;
                        __block GCMapping *mapping = nil;
                        beforeEach(^{
                            mapping = [commandMap mappingForCommand:[Append1Command class] mappedToObject:[FlagAndStringEvent class]];
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