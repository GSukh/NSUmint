#import <UIKit/UIKit.h>


@interface ChooseFacultyViewController : UIViewController

@property (nonatomic, copy) void (^cancel)(NSArray *);
@property (nonatomic) NSArray *faculties;
@property (nonatomic) BOOL singleSelection;

@end
