#import "UITableViewCell+Reusable.h"

@implementation UITableViewCell (Reusable)

+ (UINib *)nib
{
    UINib *cellNib = [UINib nibWithNibName:[self reusableIdentifier] bundle:nil];
    return cellNib;
}

+ (NSString *)reusableIdentifier
{
    return NSStringFromClass([self class]);
}

@end
