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


SPEC_BEGIN(SDObjectionCommandMapSpec)

        describe(@"SDObjectionCommandMap", ^{

            __block JSObjectionInjector *injector = nil;
            __block SDObjectionCommandMap *commandMap = nil;
            beforeEach(^{
                injector = [JSObjection createInjector];
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
                id <SDEventBus>eventBus = [injector getObject:@protocol(SDEventBus)];
                SomeEvent *event = [[SomeEvent alloc] init];
                event.object = [[SomeObject alloc] init];
                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeCommand class]];
                [eventBus postEvent:event];

                [[theValue(event.object.flag) should] beYes];
            });

            it(@"executes commands in right order", ^{
                id <SDEventBus>eventBus = [injector getObject:@protocol(SDEventBus)];
                SomeEvent *event = [[SomeEvent alloc] init];
                event.object = [[SomeObject alloc] init];

                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeCommand class]];
                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeOtherCommand class]];

                [eventBus postEvent:event];

                [[event.string should] equal:@"12"];
            });

            it(@"executes commands in right order", ^{
                id <SDEventBus>eventBus = [injector getObject:@protocol(SDEventBus)];
                SomeEvent *event = [[SomeEvent alloc] init];
                event.object = [[SomeObject alloc] init];

                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeOtherCommand class]];
                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeCommand class]];

                [eventBus postEvent:event];

                [[event.string should] equal:@"21"];
            });

            it(@"executes commands in right order", ^{
                id <SDEventBus>eventBus = [injector getObject:@protocol(SDEventBus)];
                SomeEvent *event = [[SomeEvent alloc] init];
                event.object = [[SomeObject alloc] init];

                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeCommand class] priority:10];
                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeOtherCommand class] priority:20];

                [eventBus postEvent:event];

                [[event.string should] equal:@"21"];
            });

            it(@"executes commands in right order", ^{
                id <SDEventBus>eventBus = [injector getObject:@protocol(SDEventBus)];
                SomeEvent *event = [[SomeEvent alloc] init];
                event.object = [[SomeObject alloc] init];

                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeOtherCommand class] priority:20];
                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeCommand class] priority:10];

                [eventBus postEvent:event];

                [[event.string should] equal:@"21"];
            });

            it(@"auto removes mapping", ^{
                id <SDEventBus>eventBus = [injector getObject:@protocol(SDEventBus)];
                SomeEvent *event = [[SomeEvent alloc] init];
                event.object = [[SomeObject alloc] init];

                [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeCommand class] priority:10 removeMappingAfterExecution:YES];

                [eventBus postEvent:event];
                [eventBus postEvent:event];

                [[event.string should] equal:@"1"];
            });

        });

        SPEC_END