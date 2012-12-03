//
// Created by sschmid on 03.12.12.
//
// contact@sschmid.com
//


#import "Kiwi.h"
#import "GreetingCommand.h"
#import "SDDefaultEventBus.h"
#import "SDBaseEvent.h"
#import "Objection.h"
#import "GummiModule.h"
#import "SomeCommand.h"
#import "SomeEvent.h"

SPEC_BEGIN(StressTest)

        describe(@"StressTest", ^{

            __block id <SDEventBus> eventBus = nil;
            __block id <SDCommandMap> commandMap = nil;
            __block SomeEvent *event = [[SomeEvent alloc] init];
            __block JSObjectionInjector *injector;
            beforeEach(^{
                injector = [JSObjection createInjector];
                [JSObjection setDefaultInjector:injector];
                [injector addModule:[[GummiModule alloc] init]];
                eventBus = [injector getObject:@protocol(SDEventBus)];
                commandMap = [injector getObject:@protocol(SDCommandMap)];
            });

            it(@"1000 NSObject", ^{
                for (int i=0; i<1000; ++i) {
                    [[NSObject alloc] init];
                }
            });

            it(@"100000 NSObject", ^{
                for (int i=0; i<100000; ++i) {
                    [[NSObject alloc] init];
                }
            });

            it(@"1000 SomeEvent", ^{
                for (int i=0; i<1000; ++i) {
                    [[SomeEvent alloc] init];
                }
            });

            it(@"100000 SomeEvent", ^{
                for (int i=0; i<100000; ++i) {
                    [[SomeEvent alloc] init];
                }
            });

            context(@"with mapping", ^{

                beforeEach(^{
                    [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeCommand class]];
                });

                it(@"300 event dispatch with command", ^{
                    for (int i=0; i<300; ++i) {
                        [event dispatch];
                    }
                });

                it(@"600 event dispatch with command", ^{
                    for (int i=0; i<600; ++i) {
                        [event dispatch];
                    }
                });

                it(@"1000 event dispatch with command", ^{
                    for (int i=0; i<1000; ++i) {
                        [event dispatch];
                    }
                });

                it(@"10000 event dispatch with command", ^{
                    for (int i=0; i<10000; ++i) {
                        [event dispatch];
                    }
                });

                it(@"50000 event dispatch with command", ^{
                    for (int i=0; i<50000; ++i) {
                        [event dispatch];
                    }
                });

            });

        });

        SPEC_END