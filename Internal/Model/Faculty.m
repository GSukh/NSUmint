#import "Faculty.h"


@implementation Faculty

- (instancetype)initWithDict:(NSDictionary *)dict
{
	self = [super init];
	if (self) {
		self.name = dict[@"value"];
		self.identifier = dict[@"_id"];
		self.selected = NO;
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	id copy = [[[self class] alloc] init];
	
	if (copy) {
		[copy setName:[self.name copyWithZone:zone]];
		[copy setIdentifier:[self.identifier copyWithZone:zone]];
		[copy setSelected:self.selected];
	}
	
	return copy;
}

@end
