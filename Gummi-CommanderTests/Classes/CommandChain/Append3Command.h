//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GCCommand.h"

@class FlagAndStringObject;

@interface Append3Command : NSObject <GCCommand>
@property(nonatomic, strong) FlagAndStringObject *flagAndStringObject;
@end