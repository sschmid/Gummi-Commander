//
// Created by sschmid on 20.11.12.
//
// contact@sschmid.com
//


@protocol SDEvent <NSObject>
@property(nonatomic, strong, readonly) NSString *name;
- (id)initWithName:(NSString *)name;
- (void)dispatch;
@end