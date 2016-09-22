#import <UIKit/UIKit.h>

@interface UITableViewCell (Reusable)

+ (UINib *)nib;
+ (NSString *)reusableIdentifier;

@end
