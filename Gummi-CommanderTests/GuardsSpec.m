//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Kiwi.h"
#import "YesGuard.h"

SPEC_BEGIN(GuardsSpec)

        describe(@"Guards", ^{

            __block YesGuard *g = nil;
            beforeEach(^{
                g = [[YesGuard alloc] init];
            });

            it(@"instantiates a guard", ^{
                [[g should] beKindOfClass:[YesGuard class]];
            });

            it(@"approves", ^{
                [[theValue([g approve]) should] beYes];
            });

        });

        SPEC_END