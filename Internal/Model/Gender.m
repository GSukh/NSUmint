#import "Gender.h"


@implementation Gender

+ (Gender *)male
{
	Gender *male = [[Gender alloc] init];
	male.name = @"парень";
	male.identifier = @"57bae8bb2c706b7cbdfb58ec";
	return male;
}

+ (Gender *)female
{
	Gender *female = [[Gender alloc] init];
	female.name = @"девушка";
	female.identifier = @"57bae8bb2c706b7cbdfb58ed";
	return female;
}

@end
