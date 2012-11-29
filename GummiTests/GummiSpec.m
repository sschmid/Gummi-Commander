//
// Created by sschmid on 29.11.12.
//
// contact@sschmid.com
//


#import "Kiwi.h"

SPEC_BEGIN(GummiSpec)

        describe(@"Gummi", ^{

            it(@"fails", ^{

                [[[NSObject alloc] init] shouldBeNil];

            });

        });

        SPEC_END