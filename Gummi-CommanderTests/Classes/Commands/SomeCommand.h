//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GCCommand.h"

@class SomeEvent;

@interface SomeCommand : NSObject <GCCommand>
@property(nonatomic, strong) SomeEvent *event;
@end