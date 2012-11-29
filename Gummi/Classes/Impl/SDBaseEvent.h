//
// Created by sschmid on 27.11.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "SDEvent.h"


@interface SDBaseEvent : NSObject <SDEvent>
+ (void)dispatch;

@end