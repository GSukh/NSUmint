#import <UIKit/UIKit.h>

#import "APIManager.h"


typedef NS_ENUM(NSInteger, SettingsType) {
	SettingsTypeYour,
	SettingsTypeAnotherOne
};


@class SettingsViewController;

@protocol SettingsViewControllerDelegate <NSObject>

- (void)didChangeGender:(Gender *)newGender forVC:(SettingsViewController *)settingsVC;
- (void)didSelectedFaculties:(NSArray <Faculty *> *)selectedFaculties forVC:(SettingsViewController *)settingsVC;

@end


@interface SettingsViewController : UIViewController

- (instancetype)initWithSettingsType:(SettingsType)type;

@property (nonatomic, weak) id <SettingsViewControllerDelegate> delegate;

@end
