//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GCSequenceCommand.h"
#import "GCGIAsyncCommand.h"

@class GIInjector;

@interface GCGISequenceCommand : GCGIAsyncCommand <GCSequenceCommand, GCAsyncCommandDelegate>
@property(nonatomic) BOOL stopWhenNoSuccess;
@property(nonatomic, strong) GIInjector *injector;
@end