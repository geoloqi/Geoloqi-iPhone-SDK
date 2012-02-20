//
//  TrackerSampleAppDelegate.h
//  TrackerSample
//
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrackerSampleViewController;

@interface TrackerSampleAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;

@property (strong, nonatomic) IBOutlet TrackerSampleViewController *viewController;

@end
