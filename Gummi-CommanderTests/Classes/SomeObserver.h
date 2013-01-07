//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>

@class SomeEvent;

@interface SomeObserver : NSObject
@property(nonatomic, strong) NSString *result;

- (void)m1:(SomeEvent*)event;
- (void)m2:(SomeEvent*)event;
- (void)m3:(SomeEvent*)event;
- (void)m4:(SomeEvent*)event;
- (void)m5:(SomeEvent*)event;

@end