//
// Created by sschmid on 26.11.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "SDCommand.h"

@class SomeEvent;


@interface SomeCommand : NSObject <SDCommand>
@property(nonatomic) SomeEvent *event;
@end