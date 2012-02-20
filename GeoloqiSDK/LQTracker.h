//
//  LQTracker.h
//  GeoloqiSDK
//
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/*
 The profile determines the overall behaviour of the LQTracker. See the documentation at <> for more information
 */
typedef enum {
	/*
	 Tracking is off.
	 */
	LQTrackerProfileOff = 0,

	/*
	 The lowest useful data quality.
	 Device may be either in a battery-saving mode when possible, or use more accurate location tracking when necessary to distinguish geofences.
	 Data is batched on the device, then submitted to the server later.
	 If the network drops out and reconnects, no data is lost.
	 */
	LQTrackerProfilePassive = 1,
	
	/*
	 The highest quality data available.
	 Data is batched on the device, then submitted to the server later.
	 If the network drops out and reconnects, no data is lost.
	 */
	LQTrackerProfileLogging = 2, // --available in v2
	
	/*
	 The highest quality, most real-time data available.
	 Data is transmitted as soon as possible with low-latency networking.
	 Old updates may be dropped as they are no longer relevant. (after N minutes)
	 */
	LQTrackerProfileRealtime = 3, // --available in v2

	
} LQTrackerProfile;

typedef enum {
	//
	LQTrackerStatusNotTracking,
	//There is some error or condition that prevents updating, but location data is being recorded
	LQTrackerStatusQueueing,
	LQTrackerStatusLive,
} LQTrackerStatus;


@class LQSession;

@interface LQTracker : NSObject <CLLocationManagerDelegate>

+ (id)sharedTracker;

+ (void)configureAnonymousUserAccountWithUserInfo:(NSDictionary *)userInfo profile:(LQTrackerProfile)profile;

//Once you have a valid session, set it here so location updates can be uploaded to the server
@property (nonatomic, strong) LQSession *session;

//Pre-check a profile to switch to instead of triggering an error state
- (BOOL)canSwitchToProfile:(LQTrackerProfile)profile error:(NSError **)error;

@property (nonatomic) LQTrackerProfile profile;

//What is the tracker doing now?
@property (nonatomic) LQTrackerStatus status;
//Returns the most pertinent error to the current status of the tracker, or nil if OK
@property (nonatomic, strong) NSError *errorStatus;

//Use these to determine when location data is synced up to the server
@property (nonatomic, strong, readonly) NSDate *dateOfLastLocationUpdate;
@property (nonatomic, strong, readonly) NSDate *dateOfLastSyncedLocationUpdate;

//Attempt to delete all location updates cached on the device. An error may be returned in case this fails for some reason
//- (void)deleteAllPersonalDataWithCompletion:(void (^)(NSError *dataDeletionError))block;

// Local geofencing
@property (nonatomic, strong) CLRegion *refreshTriggersRegion;
@property (nonatomic, strong) NSDate *refreshTriggersDate;
- (void)refreshNearbyTriggers;
- (void)processTriggersForLocation:(CLLocation *)location;

@end


//The tracker just recorded a point of data
extern NSString *LQTrackerDidRecordLocationNotification;


