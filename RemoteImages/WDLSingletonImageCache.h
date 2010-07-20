//
//  WDLSingletonImageCache.h
//  Native
//
//  Created by William Lindmeier on 4/12/10.
//  Copyright 2010 William Lindmeier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDLRemoteImageLoaderDelegate.h"

@class WDLCachedImageData;

@interface WDLSingletonImageCache : NSObject {
	
	NSMutableDictionary	*sharedImageCache;
	NSMutableDictionary *remoteImageDelegates;
	NSOperationQueue *imageLoadQueue;

}

@property (readonly) NSMutableDictionary * sharedImageCache;
@property (readonly) NSMutableDictionary * remoteImageDelegates;
@property (readonly) NSOperationQueue *imageLoadQueue;

- (void)handleMemoryWarning;

+ (WDLSingletonImageCache *)sharedImageCacheInstance;
+ (WDLCachedImageData *)imageCacheForURLString:(NSString *)urlString;
+ (void)loadImageForURL:(NSURL *)imageURL 
			forDelegate:(NSObject <WDLRemoteImageLoaderDelegate> *)delegate
		willBeDisplayed:(BOOL)isDisplayed;
+ (void)removeDelegate:(NSObject <WDLRemoteImageLoaderDelegate> *)delegate 
				forURL:(NSURL *)imageURL;

+ (void)setImageData:(WDLCachedImageData *)cachedData;
+ (void)imageFailedToLoadForURL:(NSURL *)imageURL;
+ (void)moveDataFromMemoryToDiskForImageAtURLString:(NSString *)URLString;
+ (BOOL)clearCache;

@end