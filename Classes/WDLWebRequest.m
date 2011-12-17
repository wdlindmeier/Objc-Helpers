//
//  WDLWebRequest.m
//  tap
//
//  Created by William Lindmeier on 6/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WDLWebRequest.h"

@implementation WDLWebRequest

@synthesize delegate, responseStatus, urlString, headerFields;

#pragma mark Requests

- (void)makeRequest:(NSURLRequest *)request
{
	[requestConnection cancel];
	[requestConnection release];
	requestConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	self.urlString = [[request URL] absoluteString];

	if (requestConnection) {
		isActive = YES;
		[receivedData release];
		receivedData = [[NSMutableData alloc] init];
	} else if(self.delegate) {
		[self.delegate webRequestConnectionFailed:self];
		if([(NSObject *)self.delegate respondsToSelector:@selector(webRequestConnectionComplete:)]){
			[self.delegate webRequestConnectionComplete:self];
		}
	}
}

- (void)cancelRequest
{
	if(isActive){
		[requestConnection cancel];
		if(self.delegate && [(NSObject *)self.delegate respondsToSelector:@selector(webRequestConnectionComplete:)]){
			[self.delegate webRequestConnectionComplete:self];
		}
	}
}

#pragma mark ---- delegate methods for the NSURLConnection class ----

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	if([response isKindOfClass:[NSHTTPURLResponse class]]){
		responseStatus = [(NSHTTPURLResponse *)response statusCode];
		[headerFields release];
		headerFields = [(NSHTTPURLResponse *)response allHeaderFields];
		[headerFields retain];
	}
	// NSLog(@"response: %@", [response URL]);
	// this method is called when the server has determined that it
	// has enough information to create the NSURLResponse
	// it can be called multiple times, for example in the case of a
	// redirect, so each time we reset the data.
	// receivedData is declared as a method instance elsewhere
	[receivedData setLength:0];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	// append the new data to the receivedData
	[receivedData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	isActive = NO;

	if(self.delegate){
		[self.delegate webRequest:self didFailWithError:[error localizedDescription]];
		if([(NSObject *)self.delegate respondsToSelector:@selector(webRequestConnectionComplete:)]){
			[self.delegate webRequestConnectionComplete:self];
		}
	}

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	// receivedData is declared as a method instance elsewhere
	// NSLog(@"Succeeded! Received %d bytes of data", [receivedData length]);

	isActive = NO;

	NSString* stringEncodedData = [[[NSString alloc] initWithData: receivedData encoding: NSUTF8StringEncoding] autorelease];

	if(self.delegate){
		// NOTE: We'll treat any response over 300 as a failure
		if(self.responseStatus < 300){
			[self.delegate webRequest:self didReturnResults:stringEncodedData];
		}else{
			[self.delegate webRequest:self didFailWithError:stringEncodedData];
		}
		if([(NSObject *)self.delegate respondsToSelector:@selector(webRequestConnectionComplete:)]){
			[self.delegate webRequestConnectionComplete:self];
		}
	}
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	//NSLog(@"didCancelAuthenticationChallenge. challenge sender: %@", [challenge sender]);
}

#pragma mark Memory

- (void)dealloc
{
	[requestConnection cancel];
	[requestConnection release]; requestConnection = nil;
	self.urlString = nil;
	[receivedData release]; receivedData = nil;
	[headerFields release]; headerFields = nil;
	[super dealloc];
}


@end
