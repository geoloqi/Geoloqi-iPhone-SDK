//
//  TrackerSampleAppDelegate.m
//  TrackerSample
//
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "TrackerSampleAppDelegate.h"

#import "TrackerSampleViewController.h"



@implementation TrackerSampleAppDelegate {
}

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)registerForPushNotifications {
    [LQSession registerForPushNotificationsWithCallback:^(NSData *deviceToken, NSError *error) {
        if(error){
            NSLog(@"Failed to register for push tokens: %@", error);
        } else {
            NSLog(@"Got a push token! %@", deviceToken);
        }
    }];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		
	self.window.rootViewController = self.viewController = [[TrackerSampleViewController alloc] initWithNibName:nil bundle:nil];
    [self.window makeKeyAndVisible];

    if([@"" isEqualToString:LQ_APIKey]) {
        [[[UIAlertView alloc] initWithTitle:@"You Need an API Key!" message:@"You need an API key from developers.geoloqi.com" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Visit Site", nil] show];
    }

    // Sets your API Key and secret
	[LQSession setAPIKey:LQ_APIKey secret:LQ_APISecret];

    // Creates a user account if not already set up.

    // Note: This will not start tracking location right now, because it would make the iPhone 
    // message "This app would like to use your location" immediately pop up when the app 
    // is launched for the first time. Instead, we create the user account and set the tracking
    // profile to "LQTrackerProfileOff", and call setProfile:LQTrackerProfilePassive when we want
    // to turn on tracking. 
    
    // If a user account has already been created, this will resume the tracker in the last state
    // it was left in when the app last quit.
    [LQTracker configureAnonymousUserAccountWithUserInfo:nil profile:LQTrackerProfileOff];

    // Tell the SDK the app finished launching so it can properly handle push notifications, etc
    [LQSession application:application didFinishLaunchingWithOptions:launchOptions];

    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://developers.geoloqi.com/ios?utm_medium=iPhone+Sample+App"]];
	if(![[UIApplication sharedApplication] openURL:url])
		NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
{
	//For push notification support, we need to get the push token from UIApplication via this method.
	//If you like, you can be notified when the relevant web service call to the Geoloqi API succeeds.
    [LQSession registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
{
    [LQSession handleDidFailToRegisterForRemoteNotifications:error];
}

/**
 * This is called when a push notification is received if the app is running in the foreground. If the app was in the
 * background when the push was received, this will be run as soon as the app is brought to the foreground by tapping the notification.
 * The SDK will also call this method in application:didFinishLaunchingWithOptions: if the app was launched because of a push notification.
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [LQSession handlePush:userInfo];
}

@end
