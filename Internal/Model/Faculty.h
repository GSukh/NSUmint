#import <Foundation/Foundation.h>


@interface Faculty : NSObject <NSCopying>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *identifier;

@property (nonatomic, getter=isSelected) BOOL selected;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (id)copyWithZone:(NSZone *)zone;

@end
