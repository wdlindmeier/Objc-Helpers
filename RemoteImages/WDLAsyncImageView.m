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
- (void)displayImageView:(UIImageView *)anImageView isCachedData:(BOOL)isCachedData;

@end

@implementation WDLAsyncImageView

@synthesize cachedData, showsActivityIndicator, imageURL, contentMode, cornerRadius;

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
	cachedData = nil;
}

#pragma mark -
#pragma mark Accessors 

/*
- (void)setCachedData:(WDLCachedImageData *)cd
{
	if(displayingCachedData && [cachedData isNotBlank]){
		cachedData.displayCount = cachedData.displayCount - 1;
		displayingCachedData = NO;
	}
	[cd retain];
	[cachedData release];
	cachedData = cd;
}
*/
#pragma mark -
#pragma mark Displaying Images 
   
- (void)loadImageFromURLString:(NSString *)aURLString {

	// Activity indicator, if you want it
	if(showsActivityIndicator){
		[self animateActivityIndicator];
	}
	
	if(aURLString){
		
		if(!showsActivityIndicator) [self displayPlaceholderImage];

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

- (void)animateActivityIndicator
{
	// NOTE: This view will be unloaded whenever a new image is displayed		
	UIActivityIndicatorView *myIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	CGSize frameSize = self.bounds.size;
	myIndicator.center = CGPointMake(frameSize.width * 0.5, frameSize.height * 0.5);
	
	myIndicator.hidesWhenStopped = YES;
	[myIndicator startAnimating];
	
	[self addSubview:myIndicator];
	[myIndicator release];	

}

- (void)displayImage:(UIImage *)anImage
{
	UIImageView *localImageView = [[[UIImageView alloc] init] initWithFrame:self.bounds];
	localImageView.image = anImage;
	[self displayImageView:localImageView isCachedData:NO];
	[localImageView release];
}

- (void)displayPlaceholderImage 
{	
	UIImageView *placeholder = [[[UIImageView alloc] init] initWithFrame:self.bounds];
	placeholder.image = [UIImage imageNamed:@"no_image.png"];
	[self displayImageView:placeholder isCachedData:NO];
	[placeholder release];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	if(imageView){
		imageView.frame = self.bounds;
		imageView.layer.cornerRadius = cornerRadius;
		imageView.layer.masksToBounds = YES;
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
		[anImageView setImage:image];
		[self displayImageView:anImageView isCachedData:YES];
		[anImageView release];
	}else{
		NSLog(@"Bad image at %@", imageCache.URLString);
	}
}

- (void)displayImageView:(UIImageView *)anImageView isCachedData:(BOOL)isCachedData
{
	if(displayingCachedData && !isCachedData){
		self.cachedData.displayCount -= 1;
	}else if(isCachedData){			
		self.cachedData.displayCount += 1;
	}
	
	displayingCachedData = isCachedData;
	
	[self removeAllSubviews];
	// No retain, no release
	imageView = anImageView;
	imageView.contentMode = self.contentMode;
	[self addSubview:imageView];		
	[self setNeedsLayout];
}

- (void)imageFailedToLoadForURL:(NSURL *)anImageURL
{
	NSLog(@"Async Image failed to load for %@", anImageURL);
	[self displayPlaceholderImage];
}

#pragma mark -
#pragma mark Memory

- (void)dealloc {
	// NOTE: No retain, no release of imageView
	self.imageURL = nil;
	self.cachedData = nil;
    [super dealloc];
}
	
@end
