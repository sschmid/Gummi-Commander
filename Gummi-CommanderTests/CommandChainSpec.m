//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Kiwi.h"
#import "GCGICommandMap.h"
#import "GCCommand.h"
#import "Append1Command.h"
#import "FlagAndStringEvent.h"
#import "FlagAndStringObject.h"
#import "GIInjector.h"
#import "GummiCommanderModule.h"
#import "Append12AndSetFlagSequenceCommand.h"
#import "Append1AsyncCommand.h"
#import "SetFlagCommand.h"
#import "Append12Async3AndSetFlagAsyncSequenceCommand.h"
#import "DoubleSequenceCommand.h"
#import "NoSuccessSequenceCommand.h"

SPEC_BEGIN(CommandChainSpec)

        describe(@"CommandChain", ^{

            __block GCGICommandMap *commandMap;
            beforeEach(^{
                [[GIInjector sharedInjector] reset];
                GIInjector *injector = [GIInjector sharedInjector];
                [injector addModule:[[GummiCommanderModule alloc] init]];
                commandMap = [injector getObject:@protocol(GCCommandMap)];
            });

            it(@"instantiates commandMap", ^{
                [[commandMap should] beKindOfClass:[GCGICommandMap class]];
            });

            it(@"executes a command", ^{
                FlagAndStringEvent *event = [[FlagAndStringEvent alloc] init];
                [commandMap mapAction:[Append1Command class] toTrigger:[event class]];
                [commandMap mapAction:[SetFlagCommand class] toTrigger:[event class]];

                [[theValue(event.object.flag) should] beNo];
                [[event.object.string should] equal:@""];

                [event dispatch];

                [[theValue(event.object.flag) should] beYes];
                [[event.object.string should] equal:@"1"];
            });

            it(@"executes an asyn command", ^{
                FlagAndStringEvent *event = [[FlagAndStringEvent alloc] init];
                [[GIInjector sharedInjector] map:event.object to:[event.object class]];
                [commandMap mapAction:[Append1AsyncCommand class] toTrigger:[event class]];
                [event dispatch];

                [[event.object.string should] equal:@""];
                [[expectFutureValue(event.object.string) shouldEventuallyBeforeTimingOutAfter(2)] equal:@"1_async"];
            });

            it(@"executes a sequence command", ^{
                FlagAndStringEvent *event = [[FlagAndStringEvent alloc] init];
                [commandMap mapAction:[Append12AndSetFlagSequenceCommand class] toTrigger:[event class]];
                [event dispatch];

                [[theValue(event.object.flag) should] beYes];
                [[event.object.string should] equal:@"12"];
            });

            it(@"executes a sequence command with async commands added", ^{
                FlagAndStringEvent *event = [[FlagAndStringEvent alloc] init];
                [commandMap mapAction:[Append12Async3AndSetFlagAsyncSequenceCommand class] toTrigger:[event class]];
                [event dispatch];

                [[expectFutureValue(event.object.string) shouldEventuallyBeforeTimingOutAfter(2)] equal:@"1_async2_async3"];
            });

            it(@"executes a sequence command with sequence command in a sequence commands", ^{
                FlagAndStringEvent *event = [[FlagAndStringEvent alloc] init];
                [commandMap mapAction:[DoubleSequenceCommand class] toTrigger:[event class]];
                [event dispatch];

                [[expectFutureValue(event.object.string) shouldEventuallyBeforeTimingOutAfter(2)] equal:@"1_async2_async32_async1_async2_async3"];
            });

            it(@"sequence stops when no success, if set to YES", ^{
                FlagAndStringEvent *event = [[FlagAndStringEvent alloc] init];
                [commandMap mapAction:[NoSuccessSequenceCommand class] toTrigger:[event class]];
                [event dispatch];

                [[expectFutureValue(event.object.string) shouldEventuallyBeforeTimingOutAfter(2)] equal:@"errorNoSuccess"];
            });

        });

        SPEC_END
