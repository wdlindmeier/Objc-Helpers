//
//  WDLImageLoadOperation.m
//  NavigationProto
//
//  Created by Bill Lindmeier on 6/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WDLImageLoadOperation.h"
#import "WDLCachedImageData.h"
#import "WDLSingletonImageCache.h"

@interface WDLImageLoadOperation()

- (void)downloadImage;

@end

@implementation WDLImageLoadOperation

@synthesize imageURL, immediatelySaveToDisk, isExecuting, isFinished;

#pragma mark -
#pragma mark Accessors

- (void)setIsFinished:(BOOL)finished
{
	[self willChangeValueForKey:@"isFinished"];
	isFinished = finished;
	[self didChangeValueForKey:@"isFinished"];	
}

- (void)setIsExecuting:(BOOL)executing
{
	[self willChangeValueForKey:@"isExecuting"];
	isExecuting = executing;
	[self didChangeValueForKey:@"isExecuting"];	
}

- (BOOL)isConcurrent 
{
	return YES;
}

- (void)setIsComplete
{
	self.isFinished = YES;
	self.isExecuting = NO;
}

#pragma mark -
#pragma mark Task 

- (void)start
{
	self.isExecuting = YES;

	[self downloadImage];
		
	[self setIsComplete];	
}

- (void)downloadImage
{
	NSString *urlString = [self.imageURL absoluteString];
	WDLCachedImageData *imageCache = [[WDLCachedImageData alloc] initWithURLString:urlString];
	imageCache.imageData = [NSMutableData dataWithContentsOfURL:self.imageURL];	
	@synchronized([WDLSingletonImageCache class]){
		if(imageCache.imageData){
			// Should this be performed in the main thread?
			[WDLSingletonImageCache setImageData:imageCache];
			if(immediatelySaveToDisk){
				[WDLSingletonImageCache moveDataFromMemoryToDiskForImageAtURLString:urlString];
			}
		}else{
			[WDLSingletonImageCache imageFailedToLoadForURL:self.imageURL];
		}
	}
	[imageCache release];
}

- (void)dealloc
{
	self.imageURL = nil;
	[super dealloc];
}

@end
