//
//  WDLSingletonImageCache.h
//  Native
//
//  Created by William Lindmeier on 4/12/10.
//  Copyright 2010 William Lindmeier. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDLCachedImageData;

@interface WDLSingletonImageCache : NSObject {
	
	NSMutableDictionary	*sharedImageCacheDictionary;
	NSOperationQueue *imageLoadQueue;

}

- (NSMutableDictionary *) getSharedImageCache;
- (void)handleMemoryWarning;

+ (WDLSingletonImageCache *)sharedImageCacheInstance;
+ (WDLCachedImageData *)imageDataForURLString:(NSString *)urlString;
+ (void)loadImageForURL:(NSURL *)imageURL;
+ (void)setImageData:(WDLCachedImageData *)cachedData;
+ (void)moveDataFromMemoryToDiskForImageAtURLString:(NSString *)URLString;
+ (BOOL)clearCache;

@end
