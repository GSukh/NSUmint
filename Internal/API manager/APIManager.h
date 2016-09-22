#import <Foundation/Foundation.h>

#import "FindingParams.h"


@interface APIManager : NSObject

+ (instancetype)sharedManager;

- (void)getFacultiesWithSuccess:(void (^)(NSArray <Faculty *> *))success
						failure:(void (^)(NSError *))failure;

- (void)postFindPartnerWithParams:(FindingParams *)params
						  success:(void (^)())success
						  failure:(void (^)(NSError *))failure;

@property (nonatomic, readonly) NSArray *faculties;

@end
