//
//  TrackerSampleViewController.m
//  TrackerSample
//
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "TrackerSampleViewController.h"


@implementation TrackerSampleViewController

@synthesize currentTrackingProfile;
@synthesize pushNotificationStatus;
@synthesize registerForPushButton;
@synthesize currentLocationField, currentLatLngLabel;
@synthesize currentLocationActivityIndicator;
@synthesize pushNotificationAlerts, pushNotificationBadges, pushNotificationSounds;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sdkLocationChanged:)
                                                 name:LQTrackerLocationChangedNotification
                                               object:nil];
    
    self.currentTrackingProfile.selectedSegmentIndex = [self segmentIndexForTrackingProfile:[[LQTracker sharedTracker] profile]];
    [self refreshPushNotificationStatus];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // Tell the SDK the user is currently interacting with the app, which gives it a chance to re-register location updates if needed
    [[LQTracker sharedTracker] appDidBecomeActive];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:LQTrackerLocationChangedNotification
                                                  object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark -

- (void)sdkLocationChanged:(NSNotification *)sender
{
    CLLocation *location = sender.object;
    self.currentLatLngLabel.text = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
}

- (void)refreshPushNotificationStatus
{
    self.pushNotificationAlerts.highlighted = [LQSession savedSession].pushAlertsEnabled;
    self.pushNotificationSounds.highlighted = [LQSession savedSession].pushSoundsEnabled;
    self.pushNotificationBadges.highlighted = [LQSession savedSession].pushBadgesEnabled;
    if([LQSession savedSession].pushAlertsEnabled) {
        self.pushNotificationStatus.text = @"Push notifications are enabled";
    } else {
        self.pushNotificationStatus.text = @"Push notifications are not enabled";
    }
}

- (int)segmentIndexForTrackingProfile:(LQTrackerProfile)profile
{
    switch(profile) {
        case LQTrackerProfileOff:      return 0;
        case LQTrackerProfileRough:    return 1;
        case LQTrackerProfileAdaptive: return 2;
        case LQTrackerProfileRealtime: return 3;
        case LQTrackerProfileLogging:  return 3;
    }
}

- (LQTrackerProfile)profileForSegmentIndex:(int)index
{
    switch(index) {
        case 0: return LQTrackerProfileOff;
        case 1: return LQTrackerProfileRough;
        case 2: return LQTrackerProfileAdaptive;
        case 3: return LQTrackerProfileRealtime;
        default: return LQTrackerProfileOff;
    }
}

- (IBAction)trackingProfileWasTapped:(UISegmentedControl *)sender
{
    NSLog(@"Tapped %d", sender.selectedSegmentIndex);
    [[LQTracker sharedTracker] setProfile:[self profileForSegmentIndex:sender.selectedSegmentIndex]];
}

#pragma mark -

- (IBAction)registerForPushWasTapped:(UIButton *)sender
{
    [LQSession registerForPushNotificationsWithCallback:^(NSData *deviceToken, NSError *error) {
        [self refreshPushNotificationStatus];
        if(error){
            self.pushNotificationStatus.text = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
            NSLog(@"Failed to register for push tokens: %@", error);
        } else {
            self.pushNotificationStatus.text = [NSString stringWithFormat:@"Successfully registered! %@", deviceToken];
            NSLog(@"Got a push token! %@", deviceToken);
        }
    }];
}

- (IBAction)getLocationButtonWasTapped:(UIButton *)sender
{
    self.currentLocationField.text = @"Loading...";
    self.currentLocationActivityIndicator.hidden = NO;
    NSURLRequest *req = [[LQSession savedSession] requestWithMethod:@"GET" path:@"/location/context" payload:nil];
    
	[[LQSession savedSession] runAPIRequest:req completion:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
		NSLog(@"Response: %@ error:%@", responseDictionary, error);
        if(error) {
            self.currentLocationField.text = [error localizedDescription];
        } else {
            NSMutableArray *loc = [NSMutableArray arrayWithCapacity:4];
            if([responseDictionary objectForKey:@"intersection"]) {
                [loc addObject:[responseDictionary objectForKey:@"intersection"]];
            }
            if([responseDictionary objectForKey:@"locality_name"]) {
                [loc addObject:[responseDictionary objectForKey:@"locality_name"]];
            }
            if([responseDictionary objectForKey:@"region_name"]) {
                [loc addObject:[responseDictionary objectForKey:@"region_name"]];
            }
            if([responseDictionary objectForKey:@"country_name"]) {
                [loc addObject:[responseDictionary objectForKey:@"country_name"]];
            }
            self.currentLocationField.text = [loc componentsJoinedByString:@", "];
        }
        self.currentLocationActivityIndicator.hidden = YES;
	}];
}

@end
