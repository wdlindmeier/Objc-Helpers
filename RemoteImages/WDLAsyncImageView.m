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

- (void)initWDLAsyncImageView;
- (void)displayImageView:(UIImageView *)anImageView;

@end

@implementation WDLAsyncImageView

@synthesize cachedData, showsActivityIndicator, imageURL, contentMode;

#pragma mark -
#pragma mark Init 

- (id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame]){
		[self initWDLAsyncImageView];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if(self = [super initWithCoder:aDecoder]){
		[self initWDLAsyncImageView];
	}
	return self;
}

- (void)initWDLAsyncImageView
{
	self.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark -
#pragma mark Displaying Images 
   
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
		
		[self displayPlaceholderImage];
		
		self.imageURL = [NSURL URLWithString:aURLString];
		
		if(imageURL){
			[WDLSingletonImageCache loadImageForURL:imageURL
										forDelegate:self
									willBeDisplayed:YES];
		}else{
			NSLog(@"%@ is not a valid URL", imageURL);
		}
		
	}else{
		
		[self displayPlaceholderImage];
		
	}
		
}

- (void)displayImage:(UIImage *)anImage
{
	UIImageView *localImageView = [[[UIImageView alloc] init] initWithFrame:self.bounds];
	localImageView.image = anImage;
	[self displayImageView:localImageView];
	[localImageView release];
}

- (void)displayPlaceholderImage {
	
	UIImageView *placeholder = [[[UIImageView alloc] init] initWithFrame:self.bounds];
	placeholder.image = [UIImage imageNamed:@"no_image.png"];
	[self displayImageView:placeholder];
	[placeholder release];
	
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	if(imageView){
		imageView.frame = self.bounds;
	}
}

#pragma mark -
#pragma mark WDLRemoteImageLoaderDelegate

- (void)imageLoadedAndCached:(WDLCachedImageData *)imageCache
{
	self.cachedData = imageCache;
	UIImage *image = [UIImage imageWithData:self.cachedData.imageData];
	if(image){
		UIImageView *anImageView = [[[UIImageView alloc] init] initWithFrame:self.bounds];
		[anImageView setImage:[UIImage imageWithData:self.cachedData.imageData]];
		[self displayImageView:anImageView];
		[anImageView release];
	}else{
		NSLog(@"Bad image at %@", imageCache.URLString);
	}
}

- (void)displayImageView:(UIImageView *)anImageView
{
	[self removeAllSubviews];
	// No retain, no release
	imageView = anImageView;
	imageView.contentMode = self.contentMode;
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
	if(self.imageURL){
		[WDLSingletonImageCache removeDelegate:self forURL:self.imageURL];
	}							  	
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
	self.imageURL = nil;
	// NOTE: No retain, no release of imageView
	self.cachedData = nil;
    [super dealloc];
}
	
@end
