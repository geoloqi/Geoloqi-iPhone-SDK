//
//  LQSession.h
//  GeoloqiSDK
//
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LQAPIObject <NSObject>
- (id)initWithSerializedRepresentation:(NSDictionary *)dictionary;
- (NSDictionary *)serializedRepresentation;
@end


/**
 * LQSession is a wrapper around the Geoloqi Web Service API, providing authentication and asynchronous APIs for making web services.
 */

@class LQLayer;
@class LQUserProfile, LQPlace;

@interface LQSession : NSObject

/**
 * Call this method first in your application delegate to set up Geoloqi api.
 */
+ (void)setAPIKey:(NSString *)APIKey secret:(NSString *)APISecret;

/** 
 * Pass off the applicationDidFinishLaunching call to the SDK
 */
+ (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/** 
 * Pass off the didRegisterForRemoteNotifications call to the SDK
 */
+ (void)registerDeviceToken:(NSData *)deviceToken;
+ (void)handleDidFailToRegisterForRemoteNotifications:(NSError *)error;

/** 
 * Call this to register for push notifications
 */
+ (void)registerForPushNotificationsWithCallback:(void (^)(NSData *deviceToken, NSError *error))block;

/**
 * If a push notification is received when your app is in the foreground, you can call this method
 * from the app delegate and the SDK will handle everything for you
 */
+ (void)handlePush:(NSDictionary *)userInfo;

- (BOOL)pushAlertsEnabled;
- (BOOL)pushBadgesEnabled;
- (BOOL)pushSoundsEnabled;

/* --------------------- SESSION MANAGEMENT ------------ */

/**
 * LQSession can persist a session for you in the keychain, or use the +sessionWithAccessToken below.
 * This is the same session as [LQTracker sharedTracker]'s session.
 */
+ (void)setSavedSession:(LQSession *)session;
+ (LQSession *)savedSession;

/**
 * Creates an LQSession object given an existing access token that is stored in
 * some sort of permanent storage on the phone or an external API.
 */
+ (LQSession *)sessionWithAccessToken:(NSString *)inAccessToken;

/**
 * Log in to an existing Geoloqi account given a username and password.
 */
+ (id)requestSessionWithUsername:(NSString *)username
						password:(NSString *)password
					  completion:(void (^)(LQSession *session, NSError *error))block;
/**
 * Create a new anonymous user account. Geoloqi will have no identifying
 * information for the user other than the properties you pass in the extraData.
 * This will actually create a new user on the Geoloqi API.
 * The SDK stores the session token locally so the account can be restored when
 * the app re-launches.
 */
+ (id)createAnonymousUserAccountWithUserInfo:(NSDictionary *)extraData 
								  completion:(void (^)(LQSession *session, NSError *error))block;

/**
 * Create a new Geoloqi account with the requested username and password.
 * The Geoloqi API will return an error if there is already a user with the
 * requested username.
 */
+ (id)createAccountWithUsername:(NSString *)username
					   password:(NSString *)password
						  extra:(NSDictionary *)extraData
					 completion:(void (^)(LQSession *session, NSError *error))block;

//Read this if you need to send the access token off to another api or you prefer to do your own persistence
@property (nonatomic, strong, readonly) NSString *accessToken;
@property (nonatomic, strong, readonly) NSString *userID;

/**
 * By default, a session creates an NSOperationQueue to talk to the server. If you want your own queue, you can do that here.
 */
@property (nonatomic, strong) NSOperationQueue *httpRequestQueue;

@end


@interface LQSession(LQSession_Advanced)

/**
 * Any of methods on LQSession that return 'id' can be passed to this method to indicate the request is no longer necessary.
 * It is not guaranteed that the request will not go through, however. The server may already have processed
 * the request, so be prepared to respond accordingly.
 */

- (void)cancelRequest:(id)request;

/**
 * As a convenience, you can use these methods to run an arbitrary API request with the current session.
 * Payload should be a JSON-compatible object of the type that the API is expecting (NSDictionary or NSArray)
 * OAuth 2.0 authorization is implemented automatically.
 */

- (NSMutableURLRequest *)requestWithMethod:(NSString *)httpMethod path:(NSString *)requestPath payload:(id)object;

/**
 * -runAPIRequest:completion: will attempt to load the resource specified by the request parameter from the geoloqi server.
 * If there is an error with HTTP loading or JSON deserialization, it will be return in the error paramater and responseDictionary will be nil,
 * while the response paramater may still contain the response recieved as applicable.
 */

- (id)runAPIRequest:(NSURLRequest *)inRequest completion:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))block;

@end


@interface LQSession (LQSession_Settings)

/**
 * If you don't want to use Geoloqi's push notification implementation, call +setPushDisabled:YES before you create an LQSession.
 */
+ (BOOL)pushDisabled;
+ (void)setPushDisabled:(BOOL)isPushDisabled;

@end


@interface LQSession (LQSession_UniqueDeviceIdentifier)

/** 
 * A device identifier will be generated and stored to NSUserDefaults unless you call -setDeviceIdentifier: with a different value
 */
+ (NSData *)deviceIdentifier;
+ (void)setDeviceIdentifier:(NSData *)deviceIdentifier;

+ (NSString *)deviceIdentifierHexString;

@end
