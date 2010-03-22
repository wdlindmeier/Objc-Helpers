//
//  WDLWebImageLoader.m
//  Geotag
//
//  Created by William Lindmeier on 4/28/09.
//  Copyright 2009. All rights reserved.
//

#import "WDLWebImageLoader.h"

@implementation WDLWebImageLoader

@synthesize delegate, imageURL;

-(void)loadImageFromURL:(NSURL *)url{
	if(isLoading)
	{
		@throw [NSException exceptionWithName:@"Load Request Ignored" 
									   reason:@"Could Not Start Load While Load In Progress" 
									 userInfo:nil];
	}
	
	isLoading = YES;
	
	self.imageURL = url;
	
	[NSThread detachNewThreadSelector:@selector(performAsyncLoadWithURL:) 
							 toTarget:self 
						   withObject:self.imageURL];	
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
	if(self.delegate) [self.delegate webImageLoader:self didLoadImage:image];
}

- (void)loadDidFinishWithError:(NSError*)error
{
	isLoading = NO;
	NSString *errorString = [NSString stringWithFormat:@"Failed to load image from %@ with error \"%@\"", 
									  imageURL, [error localizedDescription]];
	if(self.delegate) [self.delegate webImageLoader:self failedToLoadWithError:errorString];
}

- (void)dealloc 
{
	self.imageURL = nil;
	[super dealloc];
}

@end
