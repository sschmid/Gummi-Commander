//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>

@class SomeEvent;
@protocol GCCommand;

@interface SomeCommand : NSObject <GCCommand>
@property(nonatomic) SomeEvent *event;
@end