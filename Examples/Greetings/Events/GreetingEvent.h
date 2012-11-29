//
// Created by sschmid on 27.11.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "SDBaseEvent.h"


@interface GreetingEvent : SDBaseEvent
@property(nonatomic, copy) NSString *greeting;

- (id)initWithGreeting:(NSString *)greeting;

+ (void)greet:(NSString *)greeting;


@end