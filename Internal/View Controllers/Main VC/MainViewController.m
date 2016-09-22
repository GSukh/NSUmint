#import "MainViewController.h"

//#import "FAKIcon.h"
//#import "FAKFontAwesome.h"

#import "FontAwesomeKit.h"

#import "SettingsViewController.h"
#import "UIColor+customColors.h"

#import "APIManager.h"


@interface MainViewController () <UIScrollViewDelegate, SettingsViewControllerDelegate>


#pragma mark - outlets

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *youSettingsButton;
@property (weak, nonatomic) IBOutlet UIButton *anotherSettingsButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) SettingsViewController *yourSettingsVC;
@property (nonatomic, strong) SettingsViewController *anotherSettingsVC;

@property (nonatomic) BOOL youSettingsSelected;
@property (nonatomic) BOOL anotherSettingsSelected;

@property (nonatomic) BOOL searchingEnabled;


#pragma mark - data

@property (nonatomic) FindingParams *params;

@end


@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setupButtons];
	
	self.descriptionLabel.font = [UIFont fontWithName:@"FontAwesome" size:14];
	
	self.params.partnerGender = [Gender female];
	self.params.yourGender = [Gender female];
	
	
	[[APIManager sharedManager]
		getFacultiesWithSuccess:nil
		failure:^(NSError *error) {
			NSLog(@"%@", error.localizedDescription);
		}];
}

- (void)setupButtons
{
	NSError *error = nil;
	FAKFontAwesome *userIcon = [FAKFontAwesome  iconWithIdentifier:@"fa-user" size:20 error:&error];
	UIImage *userImage = [userIcon imageWithSize:CGSizeMake(50, 50)];
	[self.youSettingsButton setImage:userImage forState:UIControlStateNormal];
	self.youSettingsButton.layer.borderWidth = 1.5;
	self.youSettingsButton.layer.borderColor = [UIColor customGreenColor].CGColor;
	self.youSettingsButton.layer.cornerRadius = 5;
	[self.youSettingsButton setTintColor:[UIColor customGreenColor]];
	
	
	FAKFontAwesome *userSecretIcon = [FAKFontAwesome  iconWithIdentifier:@"fa-user-secret" size:20 error:&error];
	UIImage *userSecretImage = [userSecretIcon imageWithSize:CGSizeMake(50, 50)];
	[self.anotherSettingsButton setImage:userSecretImage forState:UIControlStateNormal];
	self.anotherSettingsButton.layer.borderWidth = 1.5;
	self.anotherSettingsButton.layer.borderColor = [UIColor customGreenColor].CGColor;
	self.anotherSettingsButton.layer.cornerRadius = 5;
	[self.anotherSettingsButton setTintColor:[UIColor customGreenColor]];
	
	
	FAKFontAwesome *searchIcon = [FAKFontAwesome  iconWithIdentifier:@"fa-search" size:20 error:&error];
	UIImage *searchImage = [searchIcon imageWithSize:CGSizeMake(50, 50)];
	[self.searchButton setImage:searchImage forState:UIControlStateNormal];
	self.searchButton.layer.borderWidth = 1.5;
	self.searchButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.searchButton.layer.cornerRadius = 5;
	[self.searchButton setTintColor:[UIColor lightGrayColor]];

}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if (!self.youSettingsSelected && !self.anotherSettingsSelected) {
		
		CGRect frame = self.yourSettingsVC.view.frame;
		frame.size.height = self.scrollView.frame.size.height;
		frame.size.width = self.scrollView.frame.size.width;
		self.yourSettingsVC.view.frame = frame;
		[self.yourSettingsVC.view layoutIfNeeded];
		
		[self addChildViewController:self.yourSettingsVC];
		[self.scrollView addSubview:self.yourSettingsVC.view];
		
		
		frame = self.anotherSettingsVC.view.frame;
		frame.origin.x = self.scrollView.frame.size.width;
		frame.size.height = self.scrollView.frame.size.height;
		frame.size.width = self.scrollView.frame.size.width;
		self.anotherSettingsVC.view.frame = frame;
		[self.anotherSettingsVC.view layoutIfNeeded];
		
		[self addChildViewController:self.anotherSettingsVC];
		[self.scrollView addSubview:self.anotherSettingsVC.view];
		
		
		frame.size.width *= 2;
		self.scrollView.contentSize = frame.size;
		self.scrollView.delegate = self;

		self.youSettingsSelected = YES;
	}
}

#pragma mark - getters

- (SettingsViewController *)yourSettingsVC
{
	if (!_yourSettingsVC) {
		_yourSettingsVC = [[SettingsViewController alloc] initWithSettingsType:SettingsTypeYour];
		_yourSettingsVC.delegate = self;
	}
	return _yourSettingsVC;
}

- (SettingsViewController *)anotherSettingsVC
{
	if (!_anotherSettingsVC) {
		_anotherSettingsVC = [[SettingsViewController alloc] initWithSettingsType:SettingsTypeAnotherOne];
		_anotherSettingsVC.delegate = self;
	}
	return _anotherSettingsVC;
}

- (FindingParams *)params
{
	if (!_params) {
		_params = [[FindingParams alloc] init];
	}
	return _params;
}


#pragma mark - Setters

- (void)setYouSettingsSelected:(BOOL)youSettingsSelected
{
	_youSettingsSelected = youSettingsSelected;
	
	if (youSettingsSelected) {
		[self selectButton:self.youSettingsButton];
	}
	else {
		[self deselectButton:self.youSettingsButton];
	}
}

- (void)setAnotherSettingsSelected:(BOOL)anotherSettingsSelected
{
	_anotherSettingsSelected = anotherSettingsSelected;

	if (anotherSettingsSelected) {
		[self selectButton:self.anotherSettingsButton];
	}
	else {
		[self deselectButton:self.anotherSettingsButton];
	}
}

- (void)selectButton:(UIButton *)button
{
	[button setTintColor:[UIColor whiteColor]];
	
	[button setBackgroundColor:[UIColor customGreenColor]];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)deselectButton:(UIButton *)button
{
	[button setTintColor:[UIColor customGreenColor]];
	
	[button setBackgroundColor:[UIColor whiteColor]];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	int indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width;
	if (indexOfPage) {
		self.youSettingsSelected = NO;
		self.anotherSettingsSelected = YES;
	}
	else {
		self.youSettingsSelected = YES;
		self.anotherSettingsSelected = NO;
	}
}


#pragma mark - SettingsViewControllerDelegate

- (void)didChangeGender:(Gender *)newGender forVC:(SettingsViewController *)settingsVC
{
	if ([settingsVC isEqual:self.yourSettingsVC]) {
		self.params.yourGender = newGender;
	}
	else if ([settingsVC isEqual:self.anotherSettingsVC]) {
		self.params.partnerGender = newGender;
	}
	[self checkData];
}

- (void)didSelectedFaculties:(NSArray <Faculty *> *)selectedFaculties forVC:(SettingsViewController *)settingsVC
{
	if ([settingsVC isEqual:self.yourSettingsVC]) {
		self.params.yourFaculty = [selectedFaculties firstObject];
	}
	else if ([settingsVC isEqual:self.anotherSettingsVC]) {
		self.params.partnerFaculties = selectedFaculties;
	}
	[self checkData];
}

- (void)checkData
{
	if (self.params.yourGender && self.params.yourFaculty && self.params.partnerGender && self.params.partnerFaculties) {
		self.searchingEnabled = YES;
		self.searchButton.layer.borderColor = [UIColor customGreenColor].CGColor;
		[self.searchButton setTintColor:[UIColor customGreenColor]];
	}
	else {
		self.searchingEnabled = NO;
		self.searchButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
		[self.searchButton setTintColor:[UIColor lightGrayColor]];
	}
}

#pragma mark - Actions

- (IBAction)yourSettingsAction
{
	if (!self.youSettingsSelected) {
		self.youSettingsSelected = !self.youSettingsSelected;
		self.anotherSettingsSelected = !self.youSettingsSelected;
		[self.scrollView scrollRectToVisible:self.yourSettingsVC.view.frame animated:YES];
	}
}

- (IBAction)anotherSettingsAction
{
	if (!self.anotherSettingsSelected) {
		self.anotherSettingsSelected = !self.anotherSettingsSelected;
		self.youSettingsSelected = !self.anotherSettingsSelected;
		[self.scrollView scrollRectToVisible:self.anotherSettingsVC.view.frame animated:YES];
	}
}

- (IBAction)searchAction
{
	[[APIManager sharedManager] postFindPartnerWithParams:self.params
												  success:nil
												  failure:nil];
}

@end
