//
//  WebRequestController.h
//  tap
//
//  Created by William Lindmeier on 6/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define kConnectionTimeoutInterval	20.0

typedef enum HTTPStatusCodes {
	HTTPStatusCodeOK					= 200,
	HTTPStatusCodeCreated				= 201,
	HTTPStatusCodeUnauthorized			= 401,
	HTTPStatusCodeUnprocessableEntity	= 422,
	HTTPStatusCodeInternalError			= 500
} HTTPStatusCode;

@class WebRequestController;

@protocol WebRequestDelegate

@optional
// This is called after after every succussful or failed connection attempt is complete
- (void)webRequestConnectionComplete:(WebRequestController *)aWebRequest;

@required

- (void)webRequest:(WebRequestController *)aWebRequest didReturnResults:(NSString *)resultString;
- (void)webRequest:(WebRequestController *)aWebRequest didFailWithError:(NSString *)errorMessage;
- (void)webRequestConnectionFailed:(WebRequestController *)aWebRequest;

@end

#import <Foundation/Foundation.h>

@interface WebRequestController : NSObject {

	id <WebRequestDelegate> delegate;
	NSInteger responseStatus;
	NSMutableData *receivedData;
	NSURLConnection *requestConnection;
	NSString *urlString;
	
}

@property (nonatomic, assign) id <WebRequestDelegate> delegate;
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
