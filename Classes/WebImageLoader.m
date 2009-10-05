//
//  WebImageLoader.m
//  Geotag
//
//  Created by William Lindmeier on 4/28/09.
//  Copyright 2009. All rights reserved.
//

#import "WebImageLoader.h"

@implementation WebImageLoader

@synthesize delegate;

-(void)loadImageFromURL:(NSString *)imageURLString{
	if(isLoading)
	{
		@throw [NSException exceptionWithName:@"Load Request Ignored" 
									   reason:@"Could Not Start Load While Load In Progress" 
									 userInfo:nil];
	}
	
	isLoading = YES;
	
	[urlString release];
	urlString = [imageURLString copy];
	
	[NSThread detachNewThreadSelector:@selector(performAsyncLoadWithURL:) 
							 toTarget:self 
						   withObject:[NSURL URLWithString:urlString]];	
}

- (void) performAsyncLoadWithURL:(NSURL*)url
{
	NSAutoreleasePool * pool =[[NSAutoreleasePool alloc] init];
	
	NSError* loadError = nil;
	NSData* imageData = [NSData dataWithContentsOfURL:url options:NSMappedRead error:&loadError];
	
	if(imageData)
	{
		[self performSelectorOnMainThread:@selector(loadDidFinishWithData:)
							   withObject:imageData 
							waitUntilDone:YES];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(loadDidFinishWithError:)
							   withObject:loadError 
							waitUntilDone:YES];
	}
	
	[pool release]; // imageData will be released here
}


- (void)loadDidFinishWithData:(NSData*)imageData
{	
	isLoading = NO;
	UIImage *image = [[[UIImage alloc] initWithData:imageData] autorelease];	
	if(self.delegate) [(NSObject *)self.delegate performSelector:@selector(webImageDidLoad:) withObject:image];
}

- (void)loadDidFinishWithError:(NSError*)error
{
	isLoading = NO;
	NSString *errorString = [NSString stringWithFormat:@"\nAPSWebImageView: Failed Image Load\n		[%@]\n		With Error - %@", 
									  urlString, [error localizedDescription]];
	if(self.delegate) [(NSObject *)self.delegate performSelector:@selector(webImageFailedToLoadWithError:) withObject:errorString];
}

- (void)dealloc 
{
	[urlString release];
	[super dealloc];
}

@end
