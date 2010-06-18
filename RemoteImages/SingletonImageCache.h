//
//  SingletonImageCache.h
//  QNow-iPhone
//
//  Created by Subu Musti on 11/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
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
+ (void)setImageData:(CachedImageData *)cachedData; // forURLString:(NSString *)urlString;
+ (void)moveDataFromMemoryToDiskForImageAtURLString:(NSString *)URLString;
+ (BOOL)clearCache;

@end
