//
// Created by sschmid on 22.11.12.
//
// contact@sschmid.com
//


#import "Kiwi.h"
#import "Objection.h"
#import "GummiModule.h"
#import "SomeEvent.h"
#import "SomeCommand.h"
#import "SomeObject.h"
#import "SomeOtherCommand.h"
#import "SDObjectionCommandMap.h"
#import "SDEventBus.h"
#import "SomeGuard.h"
#import "SDEventCommandMapping.h"
#import "NoGuard.h"
#import "YesGuard.h"
#import "DependencyGuard.h"


SPEC_BEGIN(SDObjectionCommandMapSpec)

        describe(@"SDObjectionCommandMap", ^{

            __block JSObjectionInjector *injector = nil;
            __block SDObjectionCommandMap *commandMap = nil;
            beforeEach(^{
                injector = [JSObjection createInjector];
                [JSObjection setDefaultInjector:injector];
                [injector addModule:[[GummiModule alloc] init]];
                commandMap = [injector getObject:@protocol(SDCommandMap)];
            });

            it(@"instantiates commandMap", ^{
                [commandMap shouldNotBeNil];
                [[commandMap should] beKindOfClass:[SDObjectionCommandMap class]];
            });

            it(@"has no mapping", ^{
                BOOL has = [commandMap isEventClass:[SomeEvent class] mappedToCommandClass:[SomeCommand class]];

                [[theValue(has) should] beNo];
            });

            it(@"has a mapping", ^{
                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeCommand class]];
                BOOL has = [commandMap isEventClass:[SomeEvent class] mappedToCommandClass:[SomeCommand class]];

                [[theValue(has) should] beYes];
            });

            it(@"removes mapping", ^{
                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeCommand class]];
                [commandMap unMapEventClass:[SomeEvent class] fromCommandClass:[SomeCommand class]];
                BOOL has = [commandMap isEventClass:[SomeEvent class] mappedToCommandClass:[SomeCommand class]];

                [[theValue(has) should] beNo];
            });

            it(@"removes all mappings", ^{
                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeCommand class]];
                [commandMap mapEventClass:[SomeObject class] toCommandClass:[SomeOtherCommand class]];
                [commandMap unMapAll];

                BOOL has1 = [commandMap isEventClass:[SomeEvent class] mappedToCommandClass:[SomeCommand class]];
                BOOL has2 = [commandMap isEventClass:[SomeObject class] mappedToCommandClass:[SomeOtherCommand class]];

                [[theValue(has1) should] beNo];
                [[theValue(has2) should] beNo];
            });

            it(@"executes a command", ^{
                id <SDEventBus> eventBus = [injector getObject:@protocol(SDEventBus)];
                SomeEvent *event = [[SomeEvent alloc] init];
                event.object = [[SomeObject alloc] init];
                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeCommand class]];
                [eventBus postEvent:event];

                [[theValue(event.object.flag) should] beYes];
            });

            it(@"executes commands in right order", ^{
                id <SDEventBus> eventBus = [injector getObject:@protocol(SDEventBus)];
                SomeEvent *event = [[SomeEvent alloc] init];
                event.object = [[SomeObject alloc] init];

                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeCommand class]];
                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeOtherCommand class]];

                [eventBus postEvent:event];

                [[event.string should] equal:@"12"];
            });

            it(@"executes commands in right order", ^{
                id <SDEventBus> eventBus = [injector getObject:@protocol(SDEventBus)];
                SomeEvent *event = [[SomeEvent alloc] init];
                event.object = [[SomeObject alloc] init];

                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeOtherCommand class]];
                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeCommand class]];

                [eventBus postEvent:event];

                [[event.string should] equal:@"21"];
            });

            it(@"executes commands in right order", ^{
                id <SDEventBus> eventBus = [injector getObject:@protocol(SDEventBus)];
                SomeEvent *event = [[SomeEvent alloc] init];
                event.object = [[SomeObject alloc] init];

                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeCommand class] priority:10];
                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeOtherCommand class] priority:20];

                [eventBus postEvent:event];

                [[event.string should] equal:@"21"];
            });

            it(@"executes commands in right order", ^{
                id <SDEventBus> eventBus = [injector getObject:@protocol(SDEventBus)];
                SomeEvent *event = [[SomeEvent alloc] init];
                event.object = [[SomeObject alloc] init];

                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeOtherCommand class] priority:20];
                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeCommand class] priority:10];

                [eventBus postEvent:event];

                [[event.string should] equal:@"21"];
            });

            it(@"auto removes mapping", ^{
                id <SDEventBus> eventBus = [injector getObject:@protocol(SDEventBus)];
                SomeEvent *event = [[SomeEvent alloc] init];
                event.object = [[SomeObject alloc] init];

                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeCommand class] priority:10 removeMappingAfterExecution:YES];

                [eventBus postEvent:event];
                [eventBus postEvent:event];

                [[event.string should] equal:@"1"];
            });

            context(@"guards", ^{

                it(@"has no mapping", ^{
                    SDEventCommandMapping *mapping = [commandMap mappingForEventClass:[SomeEvent class] commandClass:[SomeCommand class]];

                    [mapping shouldBeNil];
                });

                context(@"when added a mapping", ^{

                    beforeEach(^{
                        [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeCommand class]];
                    });

                    it(@"has mapping", ^{
                        SDEventCommandMapping *mapping = [commandMap mappingForEventClass:[SomeEvent class] commandClass:[SomeCommand class]];

                        [mapping shouldNotBeNil];
                        [[mapping should] beKindOfClass:[SDEventCommandMapping class]];
                    });

                    it(@"has no guards", ^{
                        SDEventCommandMapping *mapping = [commandMap mappingForEventClass:[SomeEvent class] commandClass:[SomeCommand class]];
                        BOOL has = [mapping hasGuard:[SomeGuard class]];

                        [[theValue(has) should] beNo];
                    });

                    context(@"when guards added", ^{

                        __block NSArray *guards = nil;
                        __block SDEventCommandMapping *mapping = nil;
                        beforeEach(^{
                            mapping = [commandMap mappingForEventClass:[SomeEvent class] commandClass:[SomeCommand class]];
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
                            event.object = [[SomeObject alloc] init];
                            [event dispatch];

                            [[theValue(event.object.flag) should] beNo];
                        });

                        it(@"executes command when guard approves", ^{
                            [mapping withGuards:[NSArray arrayWithObject:[YesGuard class]]];
                            SomeEvent *event = [[SomeEvent alloc] init];
                            event.object = [[SomeObject alloc] init];
                            [event dispatch];

                            [[theValue(event.object.flag) should] beYes];
                        });

                        it(@"injects dependencies into guards", ^{
                            [mapping withGuards:[NSArray arrayWithObject:[DependencyGuard class]]];
                            SomeEvent *event = [[SomeEvent alloc] init];
                            event.object = [[SomeObject alloc] init];
                            [event dispatch];

                            [[theValue(event.object.flag) should] beYes];
                        });

                    });

                });

                it(@"has guard", ^{
                    [[commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeCommand class]] withGuards:[NSArray arrayWithObject:[SomeGuard class]]];
                    BOOL has = [[commandMap mappingForEventClass:[SomeEvent class] commandClass:[SomeCommand class]] hasGuard:[SomeGuard class]];

                    [[theValue(has) should] beYes];
                });

            });

        });

        SPEC_END