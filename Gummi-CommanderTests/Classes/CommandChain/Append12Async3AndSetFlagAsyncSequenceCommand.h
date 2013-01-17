//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GCGISequenceCommand.h"

@class FlagAndStringEvent;

@interface Append12Async3AndSetFlagAsyncSequenceCommand : GCGISequenceCommand
@property(nonatomic, strong) FlagAndStringEvent *event;
@end