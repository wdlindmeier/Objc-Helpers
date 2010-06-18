//
//  WDLCachedImageData.m
//  Native
//
//  Created by William Lindmeier on 4/12/10.
//  Copyright 2010 William Lindmeier All rights reserved.
//

#import "WDLCachedImageData.h"
#import "WDLSingletonImageCache.h"

@implementation WDLCachedImageData

@synthesize imageData, displayCount, URLString;

#pragma mark Init 

- (id)initWithURLString:(NSString *)aURL
{
	if(self = [super init]){
		self.URLString = aURL;
		self.imageData = [NSMutableData data];
	}
	return self;
}

#pragma mark Accessors

- (void)setDisplayCount:(int)count
{
	// NSLog(@"DISPLAY COUNT == %i FOR url: %@", count, self.URLString);

	displayCount = count;
	// If the image is no longer displayed, move it to the disk cache
	if(count < 1 && self.URLString){
		[WDLSingletonImageCache moveDataFromMemoryToDiskForImageAtURLString:self.URLString];
	}
}

#pragma mark Memory

- (void)dealloc
{
	self.imageData = nil;
	// Move the image cache to the disk if it's no longer displayed
	if(displayCount > 0) self.displayCount = 0;
	self.URLString = nil;
	[super dealloc];
}

@end
