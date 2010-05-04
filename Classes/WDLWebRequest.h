//
//  WDLWebRequest.h
//  tap
//
//  Created by William Lindmeier on 6/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kConnectionTimeoutInterval	20.0

typedef enum HTTPStatusCodes {
	HTTPStatusCodeOK					= 200,
	HTTPStatusCodeCreated				= 201,
	HTTPStatusCodeUnauthorized			= 401,
	HTTPStatusCodeRecordNotFound		= 404,
	HTTPStatusCodeUnprocessableEntity	= 422,
	HTTPStatusCodeInternalError			= 500
} HTTPStatusCode;

@class WDLWebRequest;

@protocol WDLWebRequestDelegate

@optional
// This is called after after every succussful or failed connection attempt is complete
- (void)webRequestConnectionComplete:(WDLWebRequest *)aWebRequest;

@required

- (void)webRequest:(WDLWebRequest *)aWebRequest didReturnResults:(NSString *)resultString;
- (void)webRequest:(WDLWebRequest *)aWebRequest didFailWithError:(NSString *)errorMessage;
- (void)webRequestConnectionFailed:(WDLWebRequest *)aWebRequest;

@end

@interface WDLWebRequest : NSObject {

	id <WDLWebRequestDelegate> delegate;
	NSInteger responseStatus;
	NSMutableData *receivedData;
	NSURLConnection *requestConnection;
	NSString *urlString;
	BOOL isActive;
	
}

@property (nonatomic, assign) id <WDLWebRequestDelegate> delegate;
@property (nonatomic, readonly) NSInteger responseStatus;
@property (nonatomic, copy) NSString *urlString;

- (void)makeRequest:(NSURLRequest *)theRequest;
- (void)cancelRequest;

// NSURLConnection (faux) Delegate methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

@end
