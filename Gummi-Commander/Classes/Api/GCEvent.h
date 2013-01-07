//
// Created by Simon Schmid
//
// contact@sschmid.com
//


@protocol GCEvent <NSObject>
@property(nonatomic, copy, readonly) NSString *name;

- (id)initWithName:(NSString *)name;
- (void)dispatch;

@end