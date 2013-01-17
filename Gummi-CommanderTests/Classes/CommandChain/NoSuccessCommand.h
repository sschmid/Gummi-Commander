//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GCGIAsyncCommand.h"

@class FlagAndStringObject;

@interface NoSuccessCommand : GCGIAsyncCommand
@property(nonatomic, strong) FlagAndStringObject *flagAndStringObject;
@end