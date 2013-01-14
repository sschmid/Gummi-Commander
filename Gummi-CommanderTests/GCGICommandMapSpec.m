//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Kiwi.h"
#import "GIInjector.h"
#import "GCGICommandMap.h"
#import "GummiCommanderModule.h"
#import "SomeEvent.h"
#import "GCCommand.h"
#import "SomeCommand.h"
#import "SomeOtherCommand.h"
#import "SomeGuard.h"
#import "NoGuard.h"
#import "YesGuard.h"
#import "DependencyGuard.h"
#import "GDDispatcher.h"
#import "FlagObject.h"

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
                BOOL has = [commandMap isCommand:[SomeCommand class] mappedToObject:[SomeEvent class]];

                [[theValue(has) should] beNo];
            });

            it(@"has a mapping", ^{
                [commandMap mapCommand:[SomeCommand class] toObject:[SomeEvent class]];
                BOOL has = [commandMap isCommand:[SomeCommand class] mappedToObject:[SomeEvent class]];

                [[theValue(has) should] beYes];
            });

            it(@"removes mapping", ^{
                [commandMap mapCommand:[SomeCommand class] toObject:[SomeEvent class]];
                [commandMap unMapCommand:[SomeCommand class] fromObject:[SomeEvent class]];
                BOOL has = [commandMap isCommand:[SomeCommand class] mappedToObject:[SomeEvent class]];

                [[theValue(has) should] beNo];
            });

            it(@"removes all mappings", ^{
                [commandMap mapCommand:[SomeCommand class] toObject:[SomeEvent class]];
                [commandMap mapCommand:[SomeOtherCommand class] toObject:[SomeEvent class]];
                [commandMap unMapAll];

                BOOL has1 = [commandMap isCommand:[SomeCommand class] mappedToObject:[SomeEvent class]];
                BOOL has2 = [commandMap isCommand:[SomeOtherCommand class] mappedToObject:[SomeEvent class]];

                [[theValue(has1) should] beNo];
                [[theValue(has2) should] beNo];
            });

            it(@"executes a command", ^{
                GDDispatcher *dispatcher = [injector getObject:[GDDispatcher class]];
                SomeEvent *event = [[SomeEvent alloc] init];
                event.object = [[FlagObject alloc] init];
                [dispatcher dispatchObject:event];

                [[theValue(event.object.flag) should] beNo];
            });

            context(@"when assigned dispatcher", ^{

                beforeEach(^{
                    commandMap.dispatcher = [[GDDispatcher alloc] init];
                });

                it(@"has dispatcher", ^{
                    id dispatcher = commandMap.dispatcher;
                    [[dispatcher should] beKindOfClass:[GDDispatcher class]];
                });

                it(@"executes a command", ^{
                    SomeEvent *event = [[SomeEvent alloc] init];
                    event.object = [[FlagObject alloc] init];
                    [commandMap mapCommand:[SomeCommand class] toObject:[SomeEvent class]];
                    [commandMap.dispatcher dispatchObject:event];

                    [[theValue(event.object.flag) should] beYes];
                });

                it(@"executes commands in right order", ^{
                    SomeEvent *event = [[SomeEvent alloc] init];
                    event.object = [[FlagObject alloc] init];

                    [commandMap mapCommand:[SomeCommand class] toObject:[SomeEvent class]];
                    [commandMap mapCommand:[SomeOtherCommand class] toObject:[SomeEvent class]];

                    [commandMap.dispatcher dispatchObject:event];

                    [[event.string should] equal:@"12"];
                });

                it(@"executes commands in right order", ^{
                    SomeEvent *event = [[SomeEvent alloc] init];
                    event.object = [[FlagObject alloc] init];

                    [commandMap mapCommand:[SomeOtherCommand class] toObject:[SomeEvent class]];
                    [commandMap mapCommand:[SomeCommand class] toObject:[SomeEvent class]];

                    [commandMap.dispatcher dispatchObject:event];

                    [[event.string should] equal:@"21"];
                });

                it(@"executes commands in right order", ^{
                    SomeEvent *event = [[SomeEvent alloc] init];
                    event.object = [[FlagObject alloc] init];

                    [commandMap mapCommand:[SomeCommand class] toObject:[SomeEvent class] priority:10];
                    [commandMap mapCommand:[SomeOtherCommand class] toObject:[SomeEvent class] priority:20];

                    [commandMap.dispatcher dispatchObject:event];

                    [[event.string should] equal:@"21"];
                });

                it(@"executes commands in right order", ^{
                    SomeEvent *event = [[SomeEvent alloc] init];
                    event.object = [[FlagObject alloc] init];

                    [commandMap mapCommand:[SomeOtherCommand class] toObject:[SomeEvent class] priority:20];
                    [commandMap mapCommand:[SomeCommand class] toObject:[SomeEvent class] priority:10];

                    [commandMap.dispatcher dispatchObject:event];

                    [[event.string should] equal:@"21"];
                });

                it(@"auto removes mapping", ^{
                    SomeEvent *event = [[SomeEvent alloc] init];
                    event.object = [[FlagObject alloc] init];

                    [commandMap mapCommand:[SomeCommand class] toObject:[SomeEvent class] priority:10 removeMappingAfterExecution:YES];

                    [commandMap.dispatcher dispatchObject:event];
                    [commandMap.dispatcher dispatchObject:event];

                    [[event.string should] equal:@"1"];
                });

            });

            context(@"guards", ^{

                it(@"has no mapping", ^{
                    GCMapping *mapping = [commandMap mappingForCommand:[SomeCommand class] mappedToObject:[SomeEvent class]];

                    [mapping shouldBeNil];
                });

                context(@"when added a mapping", ^{

                    beforeEach(^{
                        [commandMap mapCommand:[SomeCommand class] toObject:[SomeEvent class]];
                    });

                    it(@"has mapping", ^{
                        GCMapping *mapping = [commandMap mappingForCommand:[SomeCommand class] mappedToObject:[SomeEvent class]];

                        [[mapping should] beKindOfClass:[GCMapping class]];
                    });

                    it(@"has no guards", ^{
                        GCMapping *mapping = [commandMap mappingForCommand:[SomeCommand class] mappedToObject:[SomeEvent class]];
                        BOOL has = [mapping hasGuard:[SomeGuard class]];

                        [[theValue(has) should] beNo];
                    });

                    context(@"when guards added", ^{

                        __block NSArray *guards = nil;
                        __block GCMapping *mapping = nil;
                        beforeEach(^{
                            mapping = [commandMap mappingForCommand:[SomeCommand class] mappedToObject:[SomeEvent class]];
                        });

                        it(@"has guard", ^{
                            guards = @[[SomeGuard class]];
                            [mapping withGuards:guards];
                            BOOL has = [mapping hasGuard:[SomeGuard class]];

                            [[theValue(has) should] beYes];
                        });

                        it(@"prevents command execution when guard does not approve", ^{
                            [mapping withGuards:@[[NoGuard class]]];
                            SomeEvent *event = [[SomeEvent alloc] init];
                            event.object = [[FlagObject alloc] init];
                            [event dispatch];

                            [[theValue(event.object.flag) should] beNo];
                        });

                        it(@"executes command when guard approves", ^{
                            [mapping withGuards:@[[YesGuard class]]];
                            SomeEvent *event = [[SomeEvent alloc] init];
                            event.object = [[FlagObject alloc] init];
                            [event dispatch];

                            [[theValue(event.object.flag) should] beYes];
                        });

                        it(@"injects dependencies into guards", ^{
                            [mapping withGuards:@[[DependencyGuard class]]];
                            SomeEvent *event = [[SomeEvent alloc] init];
                            event.object = [[FlagObject alloc] init];
                            [event dispatch];

                            [[theValue(event.object.flag) should] beYes];
                        });

                    });

                });

                it(@"has guard", ^{
                    [[commandMap mapCommand:[SomeCommand class] toObject:[SomeEvent class]] withGuards:@[[SomeGuard class]]];
                    BOOL has = [[commandMap mappingForCommand:[SomeCommand class] mappedToObject:[SomeEvent class]] hasGuard:[SomeGuard class]];

                    [[theValue(has) should] beYes];
                });

            });

        });

        SPEC_END