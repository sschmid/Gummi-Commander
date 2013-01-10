//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "Kiwi.h"
#import "GCEventBus.h"
#import "GCDefaultEventBus.h"
#import "SomeObserver.h"
#import "SomeEvent.h"


SPEC_BEGIN(GCDefaultEventBusSpec)


#pragma mark Helper blocks
        void (^hasNoObserver)(GCDefaultEventBus *, id, id <GCEvent>, SEL) = ^(GCDefaultEventBus *eventBus, id observer, id <GCEvent> event, SEL sel) {
            BOOL has1 = [eventBus hasObserver:observer forEvent:[event class] withSelector:sel];
            BOOL has2 = [eventBus hasObserver:observer forEvent:[event class]];
            BOOL has3 = [eventBus hasObserver:observer];

            [[theValue(has1) should] beNo];
            [[theValue(has2) should] beNo];
            [[theValue(has3) should] beNo];
        };

        void (^executeInOrder)(GCDefaultEventBus *, id, SEL, int, SEL, int, SEL, int, SEL, int, SEL, int) =
                ^(GCDefaultEventBus *eventBus, id observer, SEL s1, int p1, SEL s2, int p2, SEL s3, int p3, SEL s4, int p4, SEL s5, int p5) {
                    id <GCEvent> event = [[SomeEvent alloc] init];
                    [eventBus addObserver:observer forEvent:[event class] withSelector:s1 priority:p1];
                    [eventBus addObserver:observer forEvent:[event class] withSelector:s2 priority:p2];
                    [eventBus addObserver:observer forEvent:[event class] withSelector:s3 priority:p3];
                    [eventBus addObserver:observer forEvent:[event class] withSelector:s4 priority:p4];
                    [eventBus addObserver:observer forEvent:[event class] withSelector:s5 priority:p5];
                    [eventBus postEvent:event];
                };


        describe(@"GCDefaultEventBus", ^{

            __block GCDefaultEventBus *eventBus = nil;
            beforeEach(^{
                eventBus = [[GCDefaultEventBus alloc] init];
            });

            it(@"instantiates an eventbus", ^{
                [[eventBus should] beKindOfClass:[GCDefaultEventBus class]];
            });

            it(@"has no observers", ^{
                BOOL has = [eventBus hasObserver:[[NSObject alloc] init]];

                [[theValue(has) should] beNo];
            });

            it(@"has no observers for name", ^{
                BOOL has = [eventBus hasObserver:[[NSObject alloc] init] forEvent:[SomeEvent class]];

                [[theValue(has) should] beNo];
            });

            it(@"has no observers for name and selector", ^{
                BOOL has = [eventBus hasObserver:[[NSObject alloc] init] forEvent:[SomeEvent class] withSelector:@selector(test)];

                [[theValue(has) should] beNo];
            });

            context(@"when added an observer", ^{

                __block NSObject *observer = nil;
                __block id <GCEvent> event = nil;
                __block SEL sel = nil;
                beforeEach(^{
                    observer = [[NSObject alloc] init];
                    event = [[GCGIEvent alloc] init];
                    sel = @selector(test);
                    [eventBus addObserver:observer forEvent:[event class] withSelector:sel priority:0];
                });

                it(@"has observer", ^{
                    BOOL has = [eventBus hasObserver:observer];

                    [[theValue(has) should] beYes];
                });

                it(@"has observer for name", ^{
                    BOOL has = [eventBus hasObserver:observer forEvent:[event class]];

                    [[theValue(has) should] beYes];
                });

                it(@"has observer for name and selector", ^{
                    BOOL has = [eventBus hasObserver:observer forEvent:[event class] withSelector:sel];

                    [[theValue(has) should] beYes];
                });

                it(@"has no observer for wrong name", ^{
                    BOOL has = [eventBus hasObserver:observer forEvent:[SomeEvent class]];

                    [[theValue(has) should] beNo];
                });

                it(@"removes observer", ^{
                    [eventBus removeObserver:observer];
                    hasNoObserver(eventBus, observer, event, sel);
                });

                it(@"removes observer for name", ^{
                    [eventBus removeObserver:observer fromEvent:[event class]];
                    hasNoObserver(eventBus, observer, event, sel);
                });

                it(@"removes observer for name and selector", ^{
                    [eventBus removeObserver:observer fromEvent:[event class] withSelector:sel];
                    hasNoObserver(eventBus, observer, event, sel);
                });

            });

            it(@"does not add duplicates", ^{
                SomeObserver *observer = [[SomeObserver alloc] init];
                id <GCEvent> event = [[SomeEvent alloc] init];
                [eventBus addObserver:observer forEvent:[event class] withSelector:@selector(m1:) priority:0];
                [eventBus addObserver:observer forEvent:[event class] withSelector:@selector(m1:) priority:1];
                [eventBus addObserver:observer forEvent:[event class] withSelector:@selector(m1:) priority:2];
                [eventBus postEvent:[[SomeEvent alloc] init]];

                [[observer.result should] equal:@"1"];
            });

            it(@"removes the specified observer", ^{
                NSObject *observer = [[SomeObserver alloc] init];
                id <GCEvent> event = [[SomeEvent alloc] init];
                [eventBus addObserver:observer forEvent:[event class] withSelector:@selector(m1:) priority:0];
                [eventBus addObserver:observer forEvent:[event class] withSelector:@selector(m2:) priority:0];
                [eventBus removeObserver:observer fromEvent:[event class] withSelector:@selector(m1:)];
                BOOL has = [eventBus hasObserver:observer forEvent:[event class] withSelector:@selector(m1:)];
                BOOL has2 = [eventBus hasObserver:observer forEvent:[event class] withSelector:@selector(m2:)];
                [[theValue(has) should] beNo];
                [[theValue(has2) should] beYes];
            });

            it(@"removes all observers", ^{
                NSObject *observer = [[NSObject alloc] init];
                id <GCEvent> event = [[SomeEvent alloc] init];
                SEL sel = @selector(test);
                [eventBus addObserver:observer forEvent:[event class] withSelector:sel priority:0];
                [eventBus removeAllObservers];
                BOOL has1 = [eventBus hasObserver:observer forEvent:[event class] withSelector:sel];
                BOOL has2 = [eventBus hasObserver:observer forEvent:[event class]];
                BOOL has3 = [eventBus hasObserver:observer];

                [[theValue(has1) should] beNo];
                [[theValue(has2) should] beNo];
                [[theValue(has3) should] beNo];
            });

            it(@"executes in right order with priority 0", ^{
                SomeObserver *observer = [[SomeObserver alloc] init];
                executeInOrder(eventBus, observer,
                        @selector(m1:), 0,
                        @selector(m2:), 0,
                        @selector(m3:), 0,
                        @selector(m4:), 0,
                        @selector(m5:), 0
                );

                [[observer.result should] equal:@"12345"];
            });

            it(@"executes in right order depending on priority", ^{
                SomeObserver *observer = [[SomeObserver alloc] init];
                executeInOrder(eventBus, observer,
                        @selector(m1:), 2,
                        @selector(m2:), 4,
                        @selector(m3:), 6,
                        @selector(m4:), 8,
                        @selector(m5:), 10
                );

                [[observer.result should] equal:@"54321"];
            });

            it(@"executes in right order depending on priority", ^{
                SomeObserver *observer = [[SomeObserver alloc] init];
                executeInOrder(eventBus, observer,
                        @selector(m1:), 10,
                        @selector(m2:), 8,
                        @selector(m3:), 6,
                        @selector(m4:), 4,
                        @selector(m5:), 2
                );

                [[observer.result should] equal:@"12345"];
            });

            it(@"executes in right order depending on priority", ^{
                SomeObserver *observer = [[SomeObserver alloc] init];
                executeInOrder(eventBus, observer,
                        @selector(m1:), 10,
                        @selector(m2:), 6,
                        @selector(m3:), 2,
                        @selector(m4:), 4,
                        @selector(m5:), 8
                );

                [[observer.result should] equal:@"15243"];
            });

            it(@"executes in right order depending on priority", ^{
                SomeObserver *observer = [[SomeObserver alloc] init];
                executeInOrder(eventBus, observer,
                        @selector(m1:), 10,
                        @selector(m2:), 6,
                        @selector(m3:), 6,
                        @selector(m4:), 7,
                        @selector(m5:), 7
                );

                [[observer.result should] equal:@"14523"];
            });

            it(@"executes in right order depending on negative priority", ^{
                SomeObserver *observer = [[SomeObserver alloc] init];
                executeInOrder(eventBus, observer,
                        @selector(m1:), 0,
                        @selector(m2:), 1,
                        @selector(m3:), -1,
                        @selector(m4:), -3,
                        @selector(m5:), 5
                );

                [[observer.result should] equal:@"52134"];
            });

        });

        SPEC_END
