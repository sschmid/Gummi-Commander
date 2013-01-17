//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>

@class FlagAndStringEvent;
@protocol GCCommand;

@interface Append1Command : NSObject <GCCommand>
@property(nonatomic) FlagAndStringEvent *event;
@end