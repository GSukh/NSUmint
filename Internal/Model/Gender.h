#import <Foundation/Foundation.h>


@interface Gender : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *identifier;

+ (Gender *)male;
+ (Gender *)female;

@end
