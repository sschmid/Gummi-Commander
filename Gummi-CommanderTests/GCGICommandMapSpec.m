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
                BOOL has = [commandMap isEvent:[SomeEvent class] mappedToCommand:[SomeCommand class]];

                [[theValue(has) should] beNo];
            });

            it(@"has a mapping", ^{
                [commandMap mapEvent:[SomeEvent class] toCommand:[SomeCommand class]];
                BOOL has = [commandMap isEvent:[SomeEvent class] mappedToCommand:[SomeCommand class]];

                [[theValue(has) should] beYes];
            });

            it(@"removes mapping", ^{
                [commandMap mapEvent:[SomeEvent class] toCommand:[SomeCommand class]];
                [commandMap unMapEvent:[SomeEvent class] fromCommand:[SomeCommand class]];
                BOOL has = [commandMap isEvent:[SomeEvent class] mappedToCommand:[SomeCommand class]];

                [[theValue(has) should] beNo];
            });

            it(@"removes all mappings", ^{
                [commandMap mapEvent:[SomeEvent class] toCommand:[SomeCommand class]];
                [commandMap mapEvent:[SomeEvent class] toCommand:[SomeOtherCommand class]];
                [commandMap unMapAll];

                BOOL has1 = [commandMap isEvent:[SomeEvent class] mappedToCommand:[SomeCommand class]];
                BOOL has2 = [commandMap isEvent:[SomeEvent class] mappedToCommand:[SomeOtherCommand class]];

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
                    [commandMap mapEvent:[SomeEvent class] toCommand:[SomeCommand class]];
                    [commandMap.dispatcher dispatchObject:event];

                    [[theValue(event.object.flag) should] beYes];
                });

                it(@"executes commands in right order", ^{
                    SomeEvent *event = [[SomeEvent alloc] init];
                    event.object = [[FlagObject alloc] init];

                    [commandMap mapEvent:[SomeEvent class] toCommand:[SomeCommand class]];
                    [commandMap mapEvent:[SomeEvent class] toCommand:[SomeOtherCommand class]];

                    [commandMap.dispatcher dispatchObject:event];

                    [[event.string should] equal:@"12"];
                });

                it(@"executes commands in right order", ^{
                    SomeEvent *event = [[SomeEvent alloc] init];
                    event.object = [[FlagObject alloc] init];

                    [commandMap mapEvent:[SomeEvent class] toCommand:[SomeOtherCommand class]];
                    [commandMap mapEvent:[SomeEvent class] toCommand:[SomeCommand class]];

                    [commandMap.dispatcher dispatchObject:event];

                    [[event.string should] equal:@"21"];
                });

                it(@"executes commands in right order", ^{
                    SomeEvent *event = [[SomeEvent alloc] init];
                    event.object = [[FlagObject alloc] init];

                    [commandMap mapEvent:[SomeEvent class] toCommand:[SomeCommand class] priority:10];
                    [commandMap mapEvent:[SomeEvent class] toCommand:[SomeOtherCommand class] priority:20];

                    [commandMap.dispatcher dispatchObject:event];

                    [[event.string should] equal:@"21"];
                });

                it(@"executes commands in right order", ^{
                    SomeEvent *event = [[SomeEvent alloc] init];
                    event.object = [[FlagObject alloc] init];

                    [commandMap mapEvent:[SomeEvent class] toCommand:[SomeOtherCommand class] priority:20];
                    [commandMap mapEvent:[SomeEvent class] toCommand:[SomeCommand class] priority:10];

                    [commandMap.dispatcher dispatchObject:event];

                    [[event.string should] equal:@"21"];
                });

                it(@"auto removes mapping", ^{
                    SomeEvent *event = [[SomeEvent alloc] init];
                    event.object = [[FlagObject alloc] init];

                    [commandMap mapEvent:[SomeEvent class] toCommand:[SomeCommand class] priority:10 removeMappingAfterExecution:YES];

                    [commandMap.dispatcher dispatchObject:event];
                    [commandMap.dispatcher dispatchObject:event];

                    [[event.string should] equal:@"1"];
                });

            });

            context(@"guards", ^{

                it(@"has no mapping", ^{
                    GCMapping *mapping = [commandMap mappingForEvent:[SomeEvent class] command:[SomeCommand class]];

                    [mapping shouldBeNil];
                });

                context(@"when added a mapping", ^{

                    beforeEach(^{
                        [commandMap mapEvent:[SomeEvent class] toCommand:[SomeCommand class]];
                    });

                    it(@"has mapping", ^{
                        GCMapping *mapping = [commandMap mappingForEvent:[SomeEvent class] command:[SomeCommand class]];

                        [[mapping should] beKindOfClass:[GCMapping class]];
                    });

                    it(@"has no guards", ^{
                        GCMapping *mapping = [commandMap mappingForEvent:[SomeEvent class] command:[SomeCommand class]];
                        BOOL has = [mapping hasGuard:[SomeGuard class]];

                        [[theValue(has) should] beNo];
                    });

                    context(@"when guards added", ^{

                        __block NSArray *guards = nil;
                        __block GCMapping *mapping = nil;
                        beforeEach(^{
                            mapping = [commandMap mappingForEvent:[SomeEvent class] command:[SomeCommand class]];
                        });

                        it(@"has guard", ^{
                            guards = [NSArray arrayWithObject:[SomeGuard class]];
                            [mapping withGuards:guards];
                            BOOL has = [mapping hasGuard:[SomeGuard class]];

                            [[theValue(has) should] beYes];
                        });

                        it(@"prevents command execution when guard does not approve", ^{
                            [mapping withGuards:[NSArray arrayWithObject:[NoGuard class]]];
                            SomeEvent *event = [[SomeEvent alloc] init];
                            event.object = [[FlagObject alloc] init];
                            [event dispatch];

                            [[theValue(event.object.flag) should] beNo];
                        });

                        it(@"executes command when guard approves", ^{
                            [mapping withGuards:[NSArray arrayWithObject:[YesGuard class]]];
                            SomeEvent *event = [[SomeEvent alloc] init];
                            event.object = [[FlagObject alloc] init];
                            [event dispatch];

                            [[theValue(event.object.flag) should] beYes];
                        });

                        it(@"injects dependencies into guards", ^{
                            [mapping withGuards:[NSArray arrayWithObject:[DependencyGuard class]]];
                            SomeEvent *event = [[SomeEvent alloc] init];
                            event.object = [[FlagObject alloc] init];
                            [event dispatch];

                            [[theValue(event.object.flag) should] beYes];
                        });

                    });

                });

                it(@"has guard", ^{
                    [[commandMap mapEvent:[SomeEvent class] toCommand:[SomeCommand class]] withGuards:[NSArray arrayWithObject:[SomeGuard class]]];
                    BOOL has = [[commandMap mappingForEvent:[SomeEvent class] command:[SomeCommand class]] hasGuard:[SomeGuard class]];

                    [[theValue(has) should] beYes];
                });

            });

        });

        SPEC_END