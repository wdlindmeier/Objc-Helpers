//
//  WDLAsyncImageView.m
//  Native
//
//  Created by William Lindmeier on 4/12/10.
//  Copyright 2010 William Lindmeier. All rights reserved.
//

#import "WDLAsyncImageView.h"
#import "WDLSingletonImageCache.h"
#import "WDLCachedImageData.h"

// private definitions
@interface WDLAsyncImageView()

@property (nonatomic, retain) NSString *URLString;
@property (retain) WDLCachedImageData *cachedData;
- (void) refreshWithImage;

@end

@implementation WDLAsyncImageView
@synthesize URLString, cachedData;

- (void)loadImageFromURLString:(NSString *)aURLString {
	
	// Not sure if this is needed
	self.URLString = aURLString;
	
	[WDLSingletonImageCache loadImageForURL:[NSURL URLWithString:aURLString] 
								forDelegate:self];
	
	/*	
	 UIActivityIndicatorView *myIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	 myIndicator.center = self.center;
	 myIndicator.hidesWhenStopped = YES;
	 [myIndicator startAnimating];
	 [self addSubview:myIndicator];
	 [myIndicator release];
	 */			
	
}

- (void)displayPlaceholderImage {
	[self displayApplicationImage:@"no_image.png"];
}

- (void)displayApplicationImage:(NSString *)imageName {
	
	NSString *defaultImagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:defaultImagePath];
	
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.backgroundColor = UIColor.lightGrayColor;
	imageView.image = image;
	[image release];
	
	[self layoutIfNeeded];
	[self setNeedsDisplay];
	[self addSubview:imageView];
	[imageView release];

	self.contentMode = UIViewContentModeScaleAspectFit;
	
}

#pragma mark -
#pragma mark WDLRemoteImageLoaderDelegate

- (void)imageLoadedAndCached:(WDLCachedImageData *)imageCache
{
	self.cachedData = imageCache;
	
	// Increment the display count whenever we add the image to a view
	self.cachedData.displayCount += 1;
	
	UIImageView* imageView = [[[UIImageView alloc] init] initWithFrame:self.bounds];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	[imageView setImage:[UIImage imageWithData:self.cachedData.imageData]];
	[self removeAllSubviews];
	[self addSubview:imageView];
	[imageView release];
	
	self.contentMode = UIViewContentModeScaleAspectFit;
	
}

- (void)imageFailedToLoadForURL:(NSURL *)anImageURL
{
	// Do we care?
	NSLog(@"Async Image failed to load for %@", anImageURL);
	[self displayPlaceholderImage];
}

#pragma mark -
#pragma mark UIView 

/*- (void)removeFromSuperview
{
	if(cachedData){
		cachedData.displayCount -= 1;
	}	
}*/

#pragma mark -
#pragma mark Memory

- (void)dealloc {
	// NOTE: Should this be in removeFromSuperview?
	if(cachedData){
		cachedData.displayCount -= 1;
	}		
	self.cachedData = nil;
	self.URLString = nil;
    [super dealloc];
}
	
@end
