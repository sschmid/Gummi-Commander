//
// Created by sschmid on 30.11.12.
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
                [g shouldNotBeNil];
                [[g should] beKindOfClass:[SomeGuard class]];
            });

            it(@"can approve", ^{
                [g approve];
            });

        });

        SPEC_END