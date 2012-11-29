//
// Created by sschmid on 22.11.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "SDBaseEvent.h"

@class SomeObject;

@interface SomeEvent : SDBaseEvent

@property(nonatomic, strong) SomeObject *object;
@property(nonatomic, strong) NSString *string;

@end