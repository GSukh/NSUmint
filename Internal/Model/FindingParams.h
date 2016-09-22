#import <Foundation/Foundation.h>

#import "Faculty.h"
#import "Gender.h"

@interface FindingParams : NSObject

@property (nonatomic) Gender *yourGender;
@property (nonatomic) Gender *partnerGender;
@property (nonatomic) Faculty *yourFaculty;
@property (nonatomic) NSArray <Faculty *> *partnerFaculties;

@property (nonatomic, readonly) NSDictionary *params;

@end
