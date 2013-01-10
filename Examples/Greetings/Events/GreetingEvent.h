//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "GCGIEvent.h"


@interface GreetingEvent : GCGIEvent
@property(nonatomic, copy) NSString *greeting;

- (id)initWithGreeting:(NSString *)greeting;

+ (void)greet:(NSString *)greeting;

@end