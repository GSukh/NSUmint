#import "AppDelegate.h"

#import "MainViewController.h"
#import <OneSignal/OneSignal.h>

#import "SocketIO-Swift.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[self.window setRootViewController:[[MainViewController alloc] init]];
	[self.window makeKeyAndVisible];
	
	[OneSignal initWithLaunchOptions:launchOptions appId:@"3f31e6e4-edbf-4b1f-ac55-0bf775c0fc0e" handleNotificationAction:^(OSNotificationOpenedResult *result) {
		
		// This block gets called when the user reacts to a notification received
		OSNotificationPayload* payload = result.notification.payload;
		
		
		NSString* messageTitle = @"OneSignal Example";
		NSString* fullMessage = [payload.body copy];
		
		if (payload.additionalData) {
			
			if(payload.title)
				messageTitle = payload.title;
			
			NSDictionary* additionalData = payload.additionalData;
			
			if (additionalData[@"actionSelected"])
				fullMessage = [fullMessage stringByAppendingString:[NSString stringWithFormat:@"\nPressed ButtonId:%@", additionalData[@"actionSelected"]]];
		}
		
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:messageTitle
															message:fullMessage
														   delegate:self
												  cancelButtonTitle:@"Close"
												  otherButtonTitles:nil, nil];
		[alertView show];
		
	}];
	
	return YES;
}

@end
