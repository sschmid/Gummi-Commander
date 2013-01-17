//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GCGISequenceCommand.h"

@class FlagAndStringEvent;

@interface DoubleSequenceCommand : GCGISequenceCommand
@property(nonatomic, strong) FlagAndStringEvent *event;
@end