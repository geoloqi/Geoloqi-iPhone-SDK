//
//  TrackerSampleViewController.h
//  TrackerSample
//
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackerSampleViewController : UIViewController {
    
}

@property (strong) IBOutlet UISegmentedControl *currentTrackingProfile;
@property (strong) IBOutlet UITextView *pushNotificationStatus;
@property (strong) IBOutlet UIButton *registerForPushButton;
@property (strong) IBOutlet UILabel *currentLocationField;
@property (strong) IBOutlet UIActivityIndicatorView *currentLocationActivityIndicator;

@property (strong) IBOutlet UIButton *pushNotificationAlerts;
@property (strong) IBOutlet UIButton *pushNotificationBadges;
@property (strong) IBOutlet UIButton *pushNotificationSounds;



- (IBAction)trackingProfileWasTapped:(UISegmentedControl *)sender;
- (IBAction)registerForPushWasTapped:(UIButton *)sender;
- (IBAction)getLocationButtonWasTapped:(UIButton *)sender;
- (int)segmentIndexForTrackingProfile:(LQTrackerProfile)profile;

- (void)refreshPushNotificationStatus;

@end
