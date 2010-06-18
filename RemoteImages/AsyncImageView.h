//
//  Qnow_ImageView.h
//  QNow-iPhone
//
//  Created by Subu Musti on 11/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
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
//	SingletonImageCache *sharedImageCacheInstance;
//	NSMutableDictionary *sharedImageCache;
}

- (void)loadImageFromURLString:(NSString *)aURLString;
- (void)displayApplicationImage:(NSString *)imageName;
- (void)displayPlaceholderImage;

@end
