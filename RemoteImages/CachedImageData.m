//
//  CachedImageData.m
//  Native
//
//  Created by Bill Lindmeier on 4/12/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "CachedImageData.h"
#import "SingletonImageCache.h"

@implementation CachedImageData

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
		[SingletonImageCache moveDataFromMemoryToDiskForImageAtURLString:self.URLString];
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
