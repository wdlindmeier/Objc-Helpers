//
//  WDLAsyncImageView.h
//  Native
//
//  Created by William Lindmeier on 4/12/10.
//  Copyright 2010 William Lindmeier. All rights reserved.
//

#import "WDLRemoteImageLoaderDelegate.h"

@class WDLSingletonImageCache;
@class WDLCachedImageData;

@interface WDLAsyncImageView : UIView <WDLRemoteImageLoaderDelegate> {
	
@private
	
	WDLCachedImageData *cachedData;
	BOOL showsActivityIndicator;
	UIImageView *imageView;
	NSURL *imageURL;
	UIViewContentMode contentMode;	
	BOOL displayingCachedData;
}

@property (nonatomic, assign) BOOL showsActivityIndicator;
@property (nonatomic, assign) UIViewContentMode contentMode;
@property (nonatomic, retain) NSURL *imageURL;

- (void)displayPlaceholderImage;
- (void)displayImage:(UIImage *)anImage;
- (void)loadImageFromURLString:(NSString *)aURLString;
- (void)animateActivityIndicator;

@end
