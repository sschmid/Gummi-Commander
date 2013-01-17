//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "FlagAndStringEvent.h"
#import "GCCommand.h"

@interface Append2Command : NSObject <GCCommand>
@property(nonatomic) FlagAndStringEvent *event;
@end