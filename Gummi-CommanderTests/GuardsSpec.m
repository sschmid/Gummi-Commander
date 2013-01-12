//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Kiwi.h"
#import "SomeGuard.h"

SPEC_BEGIN(GuardsSpec)

        describe(@"Guards", ^{

            __block SomeGuard *g = nil;
            beforeEach(^{
                g = [[SomeGuard alloc] init];
            });

            it(@"instantiates a guard", ^{
                [[g should] beKindOfClass:[SomeGuard class]];
            });

            it(@"can approve", ^{
                [g approve];
            });

        });

        SPEC_END