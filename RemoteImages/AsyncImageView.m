//
//  Qnow_ImageView.m
//  QNow-iPhone
//
//  Created by Subu Musti on 11/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"
#import "SingletonImageCache.h"
#import "CachedImageData.h"

// private definitions
@interface AsyncImageView()
	@property (nonatomic, retain) NSString *URLString;
	@property (nonatomic, retain) NSURLConnection *URLConnection;
	@property (retain) CachedImageData *cachedData;
	- (void) refreshWithImage;
@end

@implementation AsyncImageView
@synthesize URLString, URLConnection, cachedData;

- (void)loadImageFromURLString:(NSString *)aURLString {
	
	self.URLString = aURLString;
	
	[self setBackgroundColor:[UIColor lightGrayColor]];
	self.contentMode = UIViewContentModeScaleToFill;
	
	@synchronized(self) {
	
		//First, check if the image exists in Cache.
		self.cachedData = [SingletonImageCache imageDataForURLString:self.URLString]; //[sharedImageCache valueForKey:self.URLString];
		
		if (self.cachedData) {
			// image FOUND in cache. use this
			[self refreshWithImage];
		} else {
			// image NOT-FOUND in cache, get it from the web
			URLData = [[NSMutableData alloc] init];
			NSURL *url = [[NSURL alloc] initWithString:self.URLString];
/*			UIActivityIndicatorView *myIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
			myIndicator.center = self.center;
			myIndicator.hidesWhenStopped = YES;
			[myIndicator startAnimating];
			[self addSubview:myIndicator];
			[myIndicator release];
*/			
			NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
														  cachePolicy:NSURLRequestUseProtocolCachePolicy
													  timeoutInterval:60.0];
			[url release];
			[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
			NSURLConnection *newUrlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
			[request release];

			self.URLConnection = newUrlConnection;
			[newUrlConnection release];
		}
	}	
}

- (void)refreshWithImage {
	@synchronized(self) {
		NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
				
		if(!self.cachedData){
			// We don't want more than 1 thread accessing the image cache for a particular URL
			@synchronized(self.URLString){
				CachedImageData *existingImageCache = [SingletonImageCache imageDataForURLString:self.URLString]; // [sharedImageCache valueForKey:self.URLString];		
				if(existingImageCache){
					// Whoops. We grabbed 2 at the same time. Get rid of one.
					self.cachedData = existingImageCache;				
				}else{
					CachedImageData *cache = [[CachedImageData alloc] initWithURLString:self.URLString];
					cache.imageData = URLData;
					self.cachedData = cache;
					[cache release];
					[SingletonImageCache setImageData:self.cachedData];
				}
			}
			[URLData release]; URLData = nil;
		}
		
		UIImage *image = [UIImage imageWithData:self.cachedData.imageData];
		
		// it is still possible data received is not of UIImage type.
		if (!image) {
			self.cachedData = nil;
			[self displayPlaceholderImage];
			return;
		}			
		
		// Increment the display count whenever we add the image to a view
		self.cachedData.displayCount += 1;

		UIImageView* imageView = [[[UIImageView alloc] init] initWithFrame:self.bounds];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		[imageView setImage:image];
		[imageView setBackgroundColor:[UIColor lightGrayColor]]; 
		
		[self layoutIfNeeded];
		[self setNeedsDisplay];
		[self addSubview:imageView];
		[imageView release];
		
		self.contentMode = UIViewContentModeScaleAspectFit;
		
	}
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

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	@synchronized(self) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;	
		
		// release the connection, and the data object
		[URLConnection release]; URLConnection=nil;
		[URLData release]; URLData=nil;
		
		NSLog(@"Image download failed! Error - %@ %@", [error localizedDescription],
			  [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
		if ([[self subviews] count]>0) {
			[[[self subviews] objectAtIndex:0] removeFromSuperview];
		}
		[self displayPlaceholderImage];
	}
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	@synchronized(self) {
		[URLData appendData:incrementalData];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
	@synchronized(self) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

		// release the connection, and the data object
		[URLConnection release]; URLConnection=nil;
		
		if ([[self subviews] count]>0) {
			[[[self subviews] objectAtIndex:0] removeFromSuperview];
		}
		[self performSelectorOnMainThread:@selector(refreshWithImage) withObject:nil waitUntilDone:NO];
	}
}

#pragma mark Memory

- (void)dealloc {
	if (URLConnection != nil) {
		[URLConnection cancel];
		[URLConnection release];
	}
	[URLData release];
	// NOTE: Maybe this should be in "removeFromSuperview"
	if(cachedData){
		cachedData.displayCount -= 1;
	}
	self.cachedData = nil;
	self.URLString = nil;
    [super dealloc];
}
	
@end
