//
//  WDLRemoteImageLoaderDelegate.h
//  NavigationProto
//
//  Created by Bill Lindmeier on 6/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDLCachedImageData;

@protocol WDLRemoteImageLoaderDelegate

- (void)imageLoadedAndCached:(WDLCachedImageData *)imageCache;
- (void)imageFailedToLoadForURL:(NSURL *)anImageURL;

@end