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
	
	NSString *URLString;
	WDLCachedImageData *cachedData;
	
}

- (void)loadImageFromURLString:(NSString *)aURLString;
- (void)displayApplicationImage:(NSString *)imageName;
- (void)displayPlaceholderImage;

@end
