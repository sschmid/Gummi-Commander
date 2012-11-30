//
// Created by sschmid on 30.11.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "SDBaseEvent.h"


@interface ServerResponseEvent : SDBaseEvent
@property(nonatomic, strong) NSString *response;

- (id)initWithResponse:(NSString *)response;

+ (void)dispatchWithResponse:(NSString *)response;

@end