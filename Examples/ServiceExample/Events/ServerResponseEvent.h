//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "GCGIEvent.h"


@interface ServerResponseEvent : GCGIEvent
@property(nonatomic, strong) NSString *response;

- (id)initWithResponse:(NSString *)response;

+ (void)dispatchWithResponse:(NSString *)response;

@end