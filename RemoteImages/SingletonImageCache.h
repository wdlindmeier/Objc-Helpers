//
//  SingletonImageCache.h
//  Native
//
//  Created by William Lindmeier on 4/12/10.
//  Copyright 2010 William Lindmeier. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CachedImageData;

@interface SingletonImageCache : NSObject {
	NSMutableDictionary	*sharedImageCacheDictionary;
}

- (NSMutableDictionary *) getSharedImageCache;
- (void)handleMemoryWarning;

+ (SingletonImageCache *)sharedImageCacheInstance;
+ (CachedImageData *)imageDataForURLString:(NSString *)urlString;
+ (void)setImageData:(CachedImageData *)cachedData;
+ (void)moveDataFromMemoryToDiskForImageAtURLString:(NSString *)URLString;
+ (BOOL)clearCache;

@end
