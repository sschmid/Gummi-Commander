//
// Created by sschmid on 26.11.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "SDCommand.h"
#import "SomeEvent.h"


@interface SomeOtherCommand : NSObject <SDCommand>
@property(nonatomic) SomeEvent *event;
@end