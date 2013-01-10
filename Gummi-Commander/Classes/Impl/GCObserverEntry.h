//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>

@protocol GCEvent;

@interface GCObserverEntry : NSObject
@property(nonatomic, strong) id observer;
@property(nonatomic, strong) Class eventClass;
@property(nonatomic) SEL selector;
@property(nonatomic) int priority;

- (id)initWithObserver:(id)observer event:(Class)eventClass selector:(SEL)aSelector priority:(int)priority;
- (void)execute:(id <GCEvent>)event;
@end