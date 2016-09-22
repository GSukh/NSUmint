#import "APIManager.h"

#import <AFNetworking/AFNetworking.h>


static NSString *const kBaseAPIURL = @"http://nsumint.ru/api/v1/";


@interface APIManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@property (nonatomic) NSMutableArray *mutFaculties;

@end


@implementation APIManager

- (instancetype)init
{
	self = [super init];
	if (self) {
		NSURL *apiURL = [NSURL URLWithString:kBaseAPIURL];
		
		_sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:apiURL];
		_sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
		_sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
		
		AFSecurityPolicy* security = [AFSecurityPolicy defaultPolicy];
		security.allowInvalidCertificates = YES;
		security.validatesDomainName = NO;
		_sessionManager.securityPolicy = security;
	}
	
	return self;
}

+ (instancetype)sharedManager
{
	static APIManager *sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedManager = [[APIManager alloc] init];
	});
	
	return sharedManager;
}


#pragma mark - getters
- (NSArray *)faculties
{
	return [[NSArray alloc] initWithArray:[self.mutFaculties copy] copyItems:YES];
}

- (NSMutableArray *)mutFaculties
{
	if (!_mutFaculties) {
		_mutFaculties = [NSMutableArray array];
	}
	return _mutFaculties;
}


#pragma mark - server methods

- (void)getFacultiesWithSuccess:(void (^)(NSArray <Faculty *> *))success
						failure:(void (^)(NSError *))failure
{
	[self.sessionManager
		GET:@"search_faculties"
		parameters:nil progress:nil
		success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			if (responseObject) {
				self.mutFaculties = [NSMutableArray array];
				for (NSDictionary *facDict in responseObject) {
					Faculty *fac = [[Faculty alloc] initWithDict:facDict];
					[self.mutFaculties addObject:fac];
				}
				if (success) {
					success(self.faculties);
				}
			}
		}
		failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			NSLog(@"%@", error.localizedDescription);
			if (failure) {
				failure(error);
			}
		}];
}

- (void)postFindPartnerWithParams:(FindingParams *)params
						  success:(void (^)())success
						  failure:(void (^)(NSError *))failure
{
	[self.sessionManager POST:@"partners/find"
		parameters:params.params
		progress:nil
		success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			NSLog(@"%@", responseObject);
		}
		failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			NSLog(@"%@", error.localizedDescription);
		}];
}

@end
