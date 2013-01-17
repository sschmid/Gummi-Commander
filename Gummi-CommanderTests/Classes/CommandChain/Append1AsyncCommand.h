//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GCGIAsyncCommand.h"

@class FlagAndStringObject;

@interface Append1AsyncCommand : GCGIAsyncCommand
@property(nonatomic, strong) FlagAndStringObject *flagAndStringObject;
@end