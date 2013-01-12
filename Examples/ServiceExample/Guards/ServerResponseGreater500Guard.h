//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "GCGuard.h"
#import "ServerResponseEvent.h"

@interface ServerResponseGreater500Guard : NSObject <GCGuard>
@property(nonatomic, strong) ServerResponseEvent *event;
@end