//
//  WDLAsyncImageView.h
//  Native
//
//  Created by William Lindmeier on 4/12/10.
//  Copyright 2010 William Lindmeier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDLSingletonImageCache;
@class WDLCachedImageData;

@interface WDLAsyncImageView : UIView {
@private
	NSString *URLString;
	NSURLConnection *URLConnection;
	NSMutableData *URLData;	
	WDLCachedImageData *cachedData;
}

- (void)loadImageFromURLString:(NSString *)aURLString;
- (void)displayApplicationImage:(NSString *)imageName;
- (void)displayPlaceholderImage;

@end
