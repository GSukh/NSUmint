#import "SettingsViewController.h"

#import "ChooseFacultyViewController.h"
#import "UIColor+customColors.h"


@interface SettingsViewController ()


#pragma mark - UI outlets
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;

@property (weak, nonatomic) IBOutlet UILabel *facultyLabel;
@property (weak, nonatomic) IBOutlet UIButton *facultyButton;

@property (nonatomic) BOOL maleSelected;
@property (nonatomic) BOOL femaleSelected;


#pragma mark - privat properties

@property (nonatomic) SettingsType settingsType;

@property (nonatomic) NSArray <Faculty *> *allFaculties;
@property (nonatomic) NSArray <Faculty *> *selectedFaculties;

@property (nonatomic) Gender *gender;

@end


@implementation SettingsViewController

#pragma mark - VC livecicle

- (instancetype)initWithSettingsType:(SettingsType)type
{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		self.settingsType = type;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setupButtons];
	
	self.femaleSelected = YES;
	
	switch (self.settingsType) {
		case SettingsTypeYour:
			[self setupAsYourSettingsVC];
			break;
		case SettingsTypeAnotherOne:
			[self setupAsAnotherSettingsVC];
			break;
	}
}


#pragma mark - Getters

- (NSArray <Faculty *> *)allFaculties
{
	if (!_allFaculties) {
		_allFaculties = [[APIManager sharedManager] faculties];
	}
	return _allFaculties;
}

- (NSArray *)clearFaculties
{
	NSMutableArray *mutFaculties = [NSMutableArray array];
	for (Faculty *fac in self.allFaculties) {
		fac.selected = NO;
		[mutFaculties addObject:fac];
	}
	return [mutFaculties copy];
}


#pragma mark - Setters

- (void)setMaleSelected:(BOOL)maleSelected
{
	_maleSelected = maleSelected;
	
	if (maleSelected) {
		[self selectButton:self.maleButton];
	}
	else {
		[self deselectButton:self.maleButton];
	}
}

- (void)setFemaleSelected:(BOOL)femaleSelected
{
	_femaleSelected = femaleSelected;
	
	if (femaleSelected) {
		[self selectButton:self.femaleButton];
	}
	else {
		[self deselectButton:self.femaleButton];
	}
}


#pragma mark - UI methods

- (void)setupButtons
{
	[self deselectButton:self.maleButton];
	[self deselectButton:self.femaleButton];
	
	self.facultyButton.layer.borderWidth = 1.;
	self.facultyButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.facultyButton.layer.cornerRadius = 5;
}

- (void)selectButton:(UIButton *)button
{
	button.layer.borderWidth = 1.;
	button.layer.borderColor = [UIColor customGreenColor].CGColor;
	button.layer.cornerRadius = 5;
	
	[button setBackgroundColor:[UIColor customGreenColor]];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)deselectButton:(UIButton *)button
{
	button.layer.borderWidth = 1.;
	button.layer.borderColor = [UIColor lightGrayColor].CGColor;
	button.layer.cornerRadius = 5;
	
	[button setBackgroundColor:[UIColor clearColor]];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)setupAsYourSettingsVC
{
	self.genderLabel.text = @"ВЫБЕРИТЕ СВОЙ ПОЛ";
	self.facultyLabel.text = @"ВЫБЕРИТЕ СВОЙ ФАКУЛЬТЕТ";
}

- (void)setupAsAnotherSettingsVC
{
	self.genderLabel.text = @"ВЫБЕРИТЕ ПОЛ СОБЕСЕДНИКА";
	self.facultyLabel.text = @"ВЫБЕРИТЕ ФАКУЛЬТЕТ(Ы) СОБЕСЕДНИКА";
}


#pragma mark - Actions

- (IBAction)femaleAction
{
	self.femaleSelected = !self.femaleSelected;
	self.maleSelected = !self.femaleSelected;
	self.gender = [Gender female];
	
	if (self.delegate) {
		[self.delegate didChangeGender:self.gender forVC:self];
	}
}

- (IBAction)maleAction
{
	self.maleSelected = !self.maleSelected;
	self.femaleSelected = !self.maleSelected;
	self.gender = [Gender male];
	if (self.delegate) {
		[self.delegate didChangeGender:self.gender forVC:self];
	}
}

- (IBAction)facultyAction
{
	ChooseFacultyViewController *vc = [[ChooseFacultyViewController alloc] init];
	vc.faculties = self.allFaculties;
	
	typeof(self) __weak wself = self;

	switch (self.settingsType) {
		case SettingsTypeYour:
		{
			vc.singleSelection = YES;
			vc.cancel = ^void(NSArray *selectedFaculties){
				
				Faculty *fac = [selectedFaculties firstObject];
				NSString *namesString = fac ? fac.name : @"Не выбран";
				[wself.facultyButton setTitle:namesString forState:UIControlStateNormal];
				wself.selectedFaculties = selectedFaculties;
				if (wself.delegate) {
					[wself.delegate didSelectedFaculties:selectedFaculties forVC:wself];
				}
				
			};
		}
			break;
			
		case SettingsTypeAnotherOne:
		{
			vc.singleSelection = NO;
			vc.cancel = ^void(NSArray *selectedFaculties){
				
				NSString *namesString;
				if (selectedFaculties.count == 0) {
					namesString = @"Не выбран";
				}
				else if (selectedFaculties.count <= 4) {
					NSMutableArray *names = [NSMutableArray array];
					for (Faculty *fac in selectedFaculties) {
						[names addObject:fac.name];
					}
					namesString = [names componentsJoinedByString:@", "];
				}
				else {
					namesString = [NSString stringWithFormat:@"%@ Факультетов", @(selectedFaculties.count)];
				}
				
				[wself.facultyButton setTitle:namesString forState:UIControlStateNormal];
				wself.selectedFaculties = selectedFaculties;
				
				if (wself.delegate) {
					[wself.delegate didSelectedFaculties:selectedFaculties forVC:wself];
				}
			};
		}
			break;
	}
	
	[self presentViewController:vc animated:NO completion:nil];
}

@end
