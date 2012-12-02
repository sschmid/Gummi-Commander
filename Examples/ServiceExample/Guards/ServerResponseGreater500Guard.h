//
// Created by sschmid on 02.12.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>
#import "SDGuard.h"
#import "ServerResponseEvent.h"


@interface ServerResponseGreater500Guard : NSObject <SDGuard>
@property(nonatomic, strong) ServerResponseEvent *event;
@end