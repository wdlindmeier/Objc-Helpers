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

@implementation WDLImageLoadOperation

@synthesize imageURL, immediatelySaveToDisk;

// This just loads an image as an operation in a queue and saves the data in the shared image cache
- (void)main
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
