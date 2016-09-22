#import "FindingParams.h"

#define kYourGenderId @"finder_sex_id"
#define kYourFacultyId @"finder_faculty_id"
#define kPartnerGenderIds @"sex_filter_ids"
#define kPartnerFacultyIds @"faculty_filter_ids"


@interface FindingParams ()

@property (nonatomic, readonly) NSArray <NSString *> *partnerFacultyIds;

@end


@implementation FindingParams

- (NSDictionary *)params
{
	return @{kYourGenderId : self.yourGender.identifier,
			 kYourFacultyId : self.yourFaculty.identifier,
			 kPartnerGenderIds : @[self.partnerGender.identifier],
			 kPartnerFacultyIds : self.partnerFacultyIds};
}

- (NSArray<NSString *> *)partnerFacultyIds
{
	NSMutableArray *ids = [[NSMutableArray alloc] init];
	for (Faculty *fac in self.partnerFaculties) {
		[ids addObject:fac.identifier];
	}
	return [ids copy];
}



@end
