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

@interface WDLAsyncImageView()

@property (retain) WDLCachedImageData *cachedData;

- (void)displayImageView:(UIImageView *)imageView;

@end

@implementation WDLAsyncImageView

@synthesize cachedData, showsActivityIndicator;

- (void)loadImageFromURLString:(NSString *)aURLString {
	
	// Activity indicator, if you want it
	if(showsActivityIndicator){
		UIActivityIndicatorView *myIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		myIndicator.center = self.center;
		myIndicator.hidesWhenStopped = YES;
		[myIndicator startAnimating];
		[self addSubview:myIndicator];
		[myIndicator release];
	}
	
	if(aURLString){
		
		[WDLSingletonImageCache loadImageForURL:[NSURL URLWithString:aURLString] 
									forDelegate:self
								willBeDisplayed:YES];
	}else{
		
		[self displayPlaceholderImage];
		
	}
		
}

- (void)displayPlaceholderImage {
	
	UIImageView *placeholder = [[[UIImageView alloc] init] initWithFrame:self.bounds];
	placeholder.contentMode = UIViewContentModeScaleAspectFit;
	placeholder.image = [UIImage imageNamed:@"no_image.png"];
	[self displayImageView:placeholder];
	[placeholder release];
	
}

#pragma mark -
#pragma mark WDLRemoteImageLoaderDelegate

- (void)imageLoadedAndCached:(WDLCachedImageData *)imageCache
{
	self.cachedData = imageCache;
	
	UIImageView *imageView = [[[UIImageView alloc] init] initWithFrame:self.bounds];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	[imageView setImage:[UIImage imageWithData:self.cachedData.imageData]];
	[self displayImageView:imageView];
	[imageView release];
	
}

- (void)displayImageView:(UIImageView *)imageView
{
	[self removeAllSubviews];
	[self addSubview:imageView];		
	[self setNeedsLayout];
}

- (void)imageFailedToLoadForURL:(NSURL *)anImageURL
{
	// Do we care?
	NSLog(@"Async Image failed to load for %@", anImageURL);
	[self displayPlaceholderImage];
}

#pragma mark -
#pragma mark UIView 

// These methods track how many times an image is displayed. 
// If it gets to 0, we move cached image from memory to disk.
// This is awesome.
- (void)removeFromSuperview
{
	if(cachedData){
		cachedData.displayCount -= 1;
	}	
}

- (void)didMoveToSuperview
{
	if(self.superview && cachedData){
		cachedData.displayCount += 1;
	}	
}

#pragma mark -
#pragma mark Memory

- (void)dealloc {
	self.cachedData = nil;
    [super dealloc];
}
	
@end
