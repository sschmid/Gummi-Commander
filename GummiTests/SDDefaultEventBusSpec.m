//
// Created by sschmid on 22.11.12.
//
// contact@sschmid.com
//


#import "Kiwi.h"
#import "SDDefaultEventBus.h"
#import "SomeObserver.h"
#import "SomeEvent.h"


SPEC_BEGIN(SDDefaultEventBusSpec)

        describe(@"SDDefaultEventBus", ^{

            __block SDDefaultEventBus *eventBus = nil;
            beforeEach(^{
                eventBus = [[SDDefaultEventBus alloc] init];
            });

            it(@"instantiates an eventbus", ^{
                [eventBus shouldNotBeNil];
                [[eventBus should] beKindOfClass:[SDDefaultEventBus class]];
            });

            it(@"has no observers", ^{
                BOOL has = [eventBus hasObserver:[[NSObject alloc] init]];

                [[theValue(has) should] beNo];
            });

            it(@"has no observers for name", ^{
                BOOL has = [eventBus hasObserver:[[NSObject alloc] init] name:@"testName"];

                [[theValue(has) should] beNo];
            });

            it(@"has no observers for name and selector", ^{
                BOOL has = [eventBus hasObserver:[[NSObject alloc] init] selector:@selector(test) name:@"testName"];

                [[theValue(has) should] beNo];
            });


            context(@"when added an observer", ^{

                __block NSObject *observer = nil;
                __block NSString *name = nil;
                __block SEL sel = nil;
                beforeEach(^{
                    observer = [[NSObject alloc] init];
                    name = @"testName";
                    sel = @selector(test);
                    [eventBus addObserver:observer selector:sel name:name priority:0];
                });

                it(@"has observer", ^{
                    BOOL has = [eventBus hasObserver:observer];

                    [[theValue(has) should] beYes];
                });

                it(@"has observer for name", ^{
                    BOOL has = [eventBus hasObserver:observer name:name];

                    [[theValue(has) should] beYes];
                });

                it(@"has observer for name and selector", ^{
                    BOOL has = [eventBus hasObserver:observer selector:sel name:name];

                    [[theValue(has) should] beYes];
                });

                it(@"has no observer for wrong name", ^{
                    BOOL has = [eventBus hasObserver:observer name:@"wrongName"];

                    [[theValue(has) should] beNo];
                });

                it(@"removes observer", ^{
                    [eventBus removeObserver:observer];
                    BOOL has1 = [eventBus hasObserver:observer selector:sel name:name];
                    BOOL has2 = [eventBus hasObserver:observer name:name];
                    BOOL has3 = [eventBus hasObserver:observer];

                    [[theValue(has1) should] beNo];
                    [[theValue(has2) should] beNo];
                    [[theValue(has3) should] beNo];
                });


                it(@"removes observer for name", ^{
                    [eventBus removeObserver:observer name:name];
                    BOOL has1 = [eventBus hasObserver:observer selector:sel name:name];
                    BOOL has2 = [eventBus hasObserver:observer name:name];
                    BOOL has3 = [eventBus hasObserver:observer];

                    [[theValue(has1) should] beNo];
                    [[theValue(has2) should] beNo];
                    [[theValue(has3) should] beNo];
                });

                it(@"removes observer for name and selector", ^{
                    [eventBus removeObserver:observer selector:sel name:name];
                    BOOL has1 = [eventBus hasObserver:observer selector:sel name:name];
                    BOOL has2 = [eventBus hasObserver:observer name:name];
                    BOOL has3 = [eventBus hasObserver:observer];

                    [[theValue(has1) should] beNo];
                    [[theValue(has2) should] beNo];
                    [[theValue(has3) should] beNo];
                });

            });

            it(@"removes the specified observer", ^{
                NSObject *observer = [[SomeObserver alloc] init];
                NSString *name = @"testName";
                [eventBus addObserver:observer selector:@selector(m1:) name:name priority:0];
                [eventBus addObserver:observer selector:@selector(m2:) name:name priority:0];
                [eventBus removeObserver:observer selector:@selector(m1:) name:name];
                BOOL has = [eventBus hasObserver:observer selector:@selector(m1:) name:name];
                BOOL has2 = [eventBus hasObserver:observer selector:@selector(m2:) name:name];
                [[theValue(has) should] beNo];
                [[theValue(has2) should] beYes];
            });

            it(@"removes all observers", ^{
                NSObject *observer = [[NSObject alloc] init];
                NSString *name = @"testName";
                SEL sel = @selector(test);
                [eventBus addObserver:observer selector:sel name:name priority:0];
                [eventBus removeAllObservers];
                BOOL has1 = [eventBus hasObserver:observer selector:sel name:name];
                BOOL has2 = [eventBus hasObserver:observer name:name];
                BOOL has3 = [eventBus hasObserver:observer];

                [[theValue(has1) should] beNo];
                [[theValue(has2) should] beNo];
                [[theValue(has3) should] beNo];
            });

            it(@"executes in right order with priority 0", ^{
                SomeObserver *observer = [[SomeObserver alloc] init];
                NSString *name = @"testName";
                [eventBus addObserver:observer selector:@selector(m1:) name:name priority:0];
                [eventBus addObserver:observer selector:@selector(m2:) name:name priority:0];
                [eventBus addObserver:observer selector:@selector(m3:) name:name priority:0];
                [eventBus addObserver:observer selector:@selector(m4:) name:name priority:0];
                [eventBus addObserver:observer selector:@selector(m5:) name:name priority:0];
                [eventBus postEvent:[[SomeEvent alloc] initWithName:name]];

                [[observer.result should] equal:@"12345"];
            });

            it(@"executes in right order depending on priority", ^{
                SomeObserver *observer = [[SomeObserver alloc] init];
                NSString *name = @"testName";
                [eventBus addObserver:observer selector:@selector(m1:) name:name priority:2];
                [eventBus addObserver:observer selector:@selector(m2:) name:name priority:4];
                [eventBus addObserver:observer selector:@selector(m3:) name:name priority:6];
                [eventBus addObserver:observer selector:@selector(m4:) name:name priority:8];
                [eventBus addObserver:observer selector:@selector(m5:) name:name priority:10];
                [eventBus postEvent:[[SomeEvent alloc] initWithName:name]];

                [[observer.result should] equal:@"54321"];
            });

            it(@"executes in right order depending on priority", ^{
                SomeObserver *observer = [[SomeObserver alloc] init];
                NSString *name = @"testName";
                [eventBus addObserver:observer selector:@selector(m1:) name:name priority:10];
                [eventBus addObserver:observer selector:@selector(m2:) name:name priority:8];
                [eventBus addObserver:observer selector:@selector(m3:) name:name priority:6];
                [eventBus addObserver:observer selector:@selector(m4:) name:name priority:4];
                [eventBus addObserver:observer selector:@selector(m5:) name:name priority:2];
                [eventBus postEvent:[[SomeEvent alloc] initWithName:name]];

                [[observer.result should] equal:@"12345"];
            });

            it(@"executes in right order depending on priority", ^{
                SomeObserver *observer = [[SomeObserver alloc] init];
                NSString *name = @"testName";
                [eventBus addObserver:observer selector:@selector(m1:) name:name priority:10];
                [eventBus addObserver:observer selector:@selector(m2:) name:name priority:6];
                [eventBus addObserver:observer selector:@selector(m3:) name:name priority:2];
                [eventBus addObserver:observer selector:@selector(m4:) name:name priority:4];
                [eventBus addObserver:observer selector:@selector(m5:) name:name priority:8];
                [eventBus postEvent:[[SomeEvent alloc] initWithName:name]];

                [[observer.result should] equal:@"15243"];
            });

            it(@"executes in right order depending on priority", ^{
                SomeObserver *observer = [[SomeObserver alloc] init];
                NSString *name = @"testName";
                [eventBus addObserver:observer selector:@selector(m1:) name:name priority:10];
                [eventBus addObserver:observer selector:@selector(m2:) name:name priority:6];
                [eventBus addObserver:observer selector:@selector(m3:) name:name priority:6];
                [eventBus addObserver:observer selector:@selector(m4:) name:name priority:7];
                [eventBus addObserver:observer selector:@selector(m5:) name:name priority:7];
                [eventBus postEvent:[[SomeEvent alloc] initWithName:name]];

                [[observer.result should] equal:@"14523"];
            });

        });

        SPEC_END



