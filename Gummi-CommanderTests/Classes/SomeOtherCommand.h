//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "SomeEvent.h"
#import "GCCommand.h"

@interface SomeOtherCommand : NSObject <GCCommand>
@property(nonatomic) SomeEvent *event;
@end