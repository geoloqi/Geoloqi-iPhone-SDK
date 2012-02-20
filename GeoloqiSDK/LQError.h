//
//  LQError.h
//  GeoloqiSDK
//
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

extern NSString *const LQErrorDomain;

typedef enum {
	/* Bad API key or secret*/
	LQErrorInvalidClient = 0,
	
	/* */
	//LQErrorMissingParameter,
	
	/* The access token is no longer valid. */
	LQErrorAccessTokenInvalid = 1,
	/*  */

	LQErrorLocationServicesDisabled = 2,

	LQErrorLocationServicesDenied = 3,
	
	LQErrorSignificantLocationChangeMonitoringNotAvailable = 4,
	
	LQErrorNetworkNotAvailable,
	
	LQErrorUnknownError,

} LQError;