//
//  SingletonImageCache.m
//  Native
//
//  Created by William Lindmeier on 4/12/10.
//  Copyright 2010 William Lindmeier. All rights reserved.
//

#import "WDLSingletonImageCache.h"
#import "WDLCachedImageData.h"

// private definitions
@interface WDLSingletonImageCache()

@property (nonatomic, retain) NSMutableDictionary *sharedImageCacheDictionary;

+ (NSString *)cacheDirectory;
+ (NSMutableData *)cachedImageDataForURLString:(NSString *)URLString;
+ (void)saveImageData:(NSData *)imageData fromURLString:(NSString *)URLString;

@end

@implementation WDLSingletonImageCache

@synthesize sharedImageCacheDictionary;

#pragma mark Accessors 

- (NSMutableDictionary *) getSharedImageCache {
	if (!sharedImageCacheDictionary) {
		sharedImageCacheDictionary = [[NSMutableDictionary alloc] init];
	}
	return sharedImageCacheDictionary;
}

#pragma mark Memory

- (void)handleMemoryWarning {
	NSLog(@"WDLSingletonImageCache: received memory warning");
	WDLSingletonImageCache *sharedImageCacheInstance = [WDLSingletonImageCache sharedImageCacheInstance];
	NSMutableDictionary *sharedImageCache = [sharedImageCacheInstance getSharedImageCache];
	[sharedImageCache removeAllObjects];
}

- (void) dealloc {
	//[[NSNotificationCenter defaultCenter] removeObserver:self];
	[sharedImageCacheDictionary removeAllObjects];
	[sharedImageCacheDictionary release];
	[super dealloc];
}

#pragma mark Class methods

+ (WDLSingletonImageCache *) sharedImageCacheInstance {
	static WDLSingletonImageCache *sharedImageCacheInstance;
	
	@synchronized(self) {
		if (!sharedImageCacheInstance) {
			sharedImageCacheInstance = [[WDLSingletonImageCache alloc] init];
			/*[[NSNotificationCenter defaultCenter] addObserver:self
			 selector:@selector(handleMemoryWarning) 
			 name:UIApplicationDidReceiveMemoryWarningNotification
			 object:nil];*/
		}
	}
	
	return sharedImageCacheInstance;
}

+ (WDLCachedImageData *)imageDataForURLString:(NSString *)URLString
{
	WDLCachedImageData *imageData;
	WDLSingletonImageCache *sharedImageCacheInstance = [WDLSingletonImageCache sharedImageCacheInstance];
	NSMutableDictionary *sharedImageCache = [sharedImageCacheInstance getSharedImageCache];
	imageData = [sharedImageCache valueForKey:URLString];
	if(!imageData){
		// Check the file system
		NSMutableData *urlData = [WDLSingletonImageCache cachedImageDataForURLString:URLString];
		// If it's there, save it to memory
		if(urlData){ 
			imageData = [[WDLCachedImageData alloc] initWithURLString:URLString];
			imageData.imageData = urlData;
			//[sharedImageCache setValue:imageData forKey:URLString];
			[WDLSingletonImageCache setImageData:imageData]; //forURLString:URLString];
			[imageData release];
		}
	}	
	return imageData;
}

+ (void)setImageData:(WDLCachedImageData *)cachedData
{
	WDLSingletonImageCache *sharedImageCacheInstance = [WDLSingletonImageCache sharedImageCacheInstance];
	NSMutableDictionary *sharedImageCache = [sharedImageCacheInstance getSharedImageCache];
	[sharedImageCache setValue:cachedData forKey:cachedData.URLString];
}

+ (NSData *)cachedImageDataForURLString:(NSString *)URLString
{
	NSString *escapedURLString = [URLString stringWithPercentEscape];
	
	// Find the file
	NSString *filePath = [[self cacheDirectory] stringByAppendingPathComponent:escapedURLString];

	NSData *imageData = [NSData dataWithContentsOfFile:filePath];
	/*
	if(imageData){
		NSLog(@"reviving image data from %@", URLString);
	}else{
		NSFileManager *fm = [NSFileManager defaultManager];
		if([fm fileExistsAtPath:filePath]){
			NSLog(@"file exists but not revived");
		}else {
			NSLog(@"file doesnt exist: %@\n%@", filePath, [fm contentsAtPath:[self cacheDirectory]]);
		}
	}
	*/
	return imageData;
}

+ (void)saveImageData:(NSData *)imageData fromURLString:(NSString *)URLString
{
	NSString *escapedURLString = [URLString stringWithPercentEscape];

	NSString *filePath = [[self cacheDirectory] stringByAppendingPathComponent:escapedURLString];
	
	// Check if there's a file there. If not, write it.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL imageExists = [fileManager fileExistsAtPath:filePath];
	
	if(!imageExists){
		BOOL success = [imageData writeToFile:filePath atomically:YES];
		if(!success){
			NSLog(@"ERROR writing image to cache: %@", filePath);
		}
	}
}

+ (void)moveDataFromMemoryToDiskForImageAtURLString:(NSString *)URLString
{
	WDLSingletonImageCache *sharedImageCacheInstance = [WDLSingletonImageCache sharedImageCacheInstance];
	NSMutableDictionary *sharedImageCache = [sharedImageCacheInstance getSharedImageCache];
	WDLCachedImageData *cachedData = [sharedImageCache valueForKey:URLString];
	if(cachedData){		
//		NSLog(@"Moving image to disk cache: %@", URLString);
		[self saveImageData:cachedData.imageData fromURLString:URLString];
		[sharedImageCache removeObjectForKey:URLString];
	}						 
}

+ (NSString *)cacheDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
	
	NSString *documentsPath = [paths objectAtIndex:0];
	NSString *cachePath = [documentsPath stringByAppendingPathComponent:@"imagecache"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDirectory;
	BOOL cachePathExists = [fileManager fileExistsAtPath:cachePath isDirectory:&isDirectory];	 
	if(!cachePathExists){
		// Create the cache path
		NSError *fsError;
		BOOL success = [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:&fsError];
		if(!success){
			NSLog(@"ERROR creating cachepath: %@", fsError);
			return nil;
		}
	}
    return cachePath;
}

+ (BOOL)clearCache
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *fsError;
//	NSLog(@"cache contents: %@", [fileManager directoryContentsAtPath:[self cacheDirectory]]);
	BOOL success = [fileManager removeItemAtPath:[self cacheDirectory] error:&fsError];
	if(!success){
		NSLog(@"ERROR clearing image cache: %@", fsError);
	}
	return success;
}

@end