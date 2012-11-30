//
// Created by sschmid on 30.11.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "SDCommand.h"

@class ServerResponseEvent;
@class Model;


@interface ServerResponseCommand : NSObject <SDCommand>
@property(nonatomic, strong) ServerResponseEvent *event;
@property(nonatomic, strong) Model *model;
@end