#import "ChooseFacultyViewController.h"

#import "FacultyTableViewCell.h"
#import "UITableViewCell+Reusable.h"
#import "UIColor+customColors.h"

#import "Faculty.h"


@interface ChooseFacultyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end


@implementation ChooseFacultyViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.tableView registerNib:[FacultyTableViewCell nib] forCellReuseIdentifier:[FacultyTableViewCell reusableIdentifier]];
	
	UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTap)];
	[self.backgroundView addGestureRecognizer:tapGR];
}


#pragma mark - actions

- (void)onViewTap
{
	NSMutableArray *selectedFaculties = [NSMutableArray array];
	for (Faculty *fac in self.faculties) {
		if (fac.isSelected) {
			[selectedFaculties addObject:fac];
		}
	}
	self.cancel(selectedFaculties);
	[self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.faculties count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FacultyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FacultyTableViewCell reusableIdentifier] forIndexPath:indexPath];
	
	Faculty *fac = self.faculties[indexPath.row];
	cell.nameLabel.text = fac.name;
	cell.nameLabel.textColor = fac.selected ? [UIColor whiteColor] : [UIColor blackColor];
	
	cell.backgroundColor = fac.selected ? [UIColor customGreenColor] : [UIColor whiteColor];
	
	return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 1.;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 1.;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	Faculty *selectedFac = self.faculties[indexPath.row];
	
	if (self.singleSelection) {
		for (Faculty *fac in self.faculties) {
			fac.selected = NO;
		}
		selectedFac.selected = YES;
	}
	else {
		selectedFac.selected = !selectedFac.selected;
	}
	
	[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	
	if (self.singleSelection) {
		[self performSelector:@selector(onViewTap) withObject:nil afterDelay:0.3];
	}
}

@end
