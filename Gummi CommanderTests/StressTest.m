//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "Kiwi.h"
//#import "GreetingCommand.h"
//#import "SomeCommand.h"
//#import "GCEvent.h"
//#import "SomeEvent.h"
//#import "GIInjector.h"
//#import "GCEventBus.h"
//#import "GCGICommandMap.h"
//#import "GummiCommander.h"

SPEC_BEGIN(StressTest)

        describe(@"StressTest", ^{

            return;

//            __block id <GCEventBus> eventBus = nil;
//            __block id <GCGICommandMap> commandMap = nil;
//            __block SomeEvent *event = [[SomeEvent alloc] init];
//            __block GIInjector *injector;
//            beforeEach(^{
//                injector = [[GIInjector alloc] init];
//                [injector addModule:[[GummiCommander alloc] init]];
//                eventBus = [injector getObject:@protocol(GCEventBus)];
//                commandMap = [injector getObject:@protocol(GCGICommandMap)];
//            });
//
//            it(@"1000 NSObject", ^{
//                for (int i=0; i<1000; ++i) {
//                    [[NSObject alloc] init];
//                }
//            });
//
//            it(@"100000 NSObject", ^{
//                for (int i=0; i<100000; ++i) {
//                    [[NSObject alloc] init];
//                }
//            });
//
//            it(@"1000 SomeEvent", ^{
//                for (int i=0; i<1000; ++i) {
//                    [[SomeEvent alloc] init];
//                }
//            });
//
//            it(@"100000 SomeEvent", ^{
//                for (int i=0; i<100000; ++i) {
//                    [[SomeEvent alloc] init];
//                }
//            });
//
//            context(@"with mapping", ^{
//
//                beforeEach(^{
//                    [commandMap mapEventClass:[SomeEvent class] toCommandClass:[SomeCommand class]];
//                });
//
//                it(@"300 event dispatch with command", ^{
//                    for (int i=0; i<300; ++i) {
//                        [event dispatch];
//                    }
//                });
//
//                it(@"600 event dispatch with command", ^{
//                    for (int i=0; i<600; ++i) {
//                        [event dispatch];
//                    }
//                });
//
//                it(@"1000 event dispatch with command", ^{
//                    for (int i=0; i<1000; ++i) {
//                        [event dispatch];
//                    }
//                });
//
//                it(@"10000 event dispatch with command", ^{
//                    for (int i=0; i<10000; ++i) {
//                        [event dispatch];
//                    }
//                });
//
//                it(@"50000 event dispatch with command", ^{
//                    for (int i=0; i<50000; ++i) {
//                        [event dispatch];
//                    }
//                });
//
//            });
//
        });

        SPEC_END