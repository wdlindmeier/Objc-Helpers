//
//  AsyncImageView.h
//  Native
//
//  Created by William Lindmeier on 4/12/10.
//  Copyright 2010 William Lindmeier. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SingletonImageCache;
@class CachedImageData;

@interface AsyncImageView : UIView {
@private
	NSString *URLString;
	NSURLConnection *URLConnection;
	NSMutableData *URLData;	
	CachedImageData *cachedData;
}

- (void)loadImageFromURLString:(NSString *)aURLString;
- (void)displayApplicationImage:(NSString *)imageName;
- (void)displayPlaceholderImage;

@end
