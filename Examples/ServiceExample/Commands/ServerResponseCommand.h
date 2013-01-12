//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GCCommand.h"

@class ServerResponseEvent;
@class Model;

@interface ServerResponseCommand : NSObject <GCCommand>
@property(nonatomic, strong) ServerResponseEvent *event;
@property(nonatomic, strong) Model *model;
@end