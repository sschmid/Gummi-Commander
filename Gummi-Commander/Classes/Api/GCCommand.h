//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>

@protocol GCCommand <NSObject>
- (void)execute;
@end