//
//  SingletonImageCache.m
//  Native
//
//  Created by William Lindmeier on 4/12/10.
//  Copyright 2010 William Lindmeier. All rights reserved.
//

#import "WDLSingletonImageCache.h"
#import "WDLCachedImageData.h"
#import "WDLImageLoadOperation.h"

// private definitions
@interface WDLSingletonImageCache()

- (void)loadImageForURL:(NSURL *)imageURL 
			forDelegate:(NSObject <WDLRemoteImageLoaderDelegate> *)delegate
		willBeDisplayed:(BOOL)isDisplayed;

+ (NSString *)cacheDirectory;
+ (NSMutableData *)imageDataForURLString:(NSString *)URLString;
+ (void)saveImageData:(NSData *)imageData fromURLString:(NSString *)URLString;

@end

@implementation WDLSingletonImageCache

@synthesize sharedImageCache, remoteImageDelegates, imageLoadQueue;

#pragma mark -
#pragma mark Init

- (id)init
{
	if(self = [super init]){
		imageLoadQueue = [[NSOperationQueue alloc] init];
		remoteImageDelegates = [[NSMutableDictionary alloc] init];
		sharedImageCache = [[NSMutableDictionary alloc] init];
	}
	return self;
}

#pragma mark -
#pragma mark Loading Images 

- (void)loadImageForURL:(NSURL *)imageURL 
			forDelegate:(NSObject <WDLRemoteImageLoaderDelegate> *)delegate
		willBeDisplayed:(BOOL)isDisplayed
{
	@synchronized([WDLSingletonImageCache class]){
		// If the URL is already loaded, dont bother
		WDLCachedImageData *imageCache = [WDLSingletonImageCache imageCacheForURLString:[imageURL absoluteString]];
		if(imageCache){
			// The image is already cached. Inform the delegate
			[delegate imageLoadedAndCached:imageCache];
		}else{
			if(delegate){
				// Save the delegate in a delegate dictionary
				// These will be called when the image has loaded (in setImageData)
				NSString *urlKey = [imageURL absoluteString];
				NSMutableArray *imageDelegates = [remoteImageDelegates objectForKey:urlKey];
				if(!imageDelegates){
					imageDelegates = [NSMutableArray array];
					[remoteImageDelegates setObject:imageDelegates forKey:urlKey];				
				}
				[imageDelegates addObject:delegate];
			}
			
			// Queue up an operation to load the image
			WDLImageLoadOperation *imageLoader = [[WDLImageLoadOperation alloc] init];
			imageLoader.imageURL = imageURL;
			imageLoader.immediatelySaveToDisk = !isDisplayed;
			[imageLoadQueue addOperation:imageLoader];
			[imageLoader release];		
		}
	}
}

#pragma -
#pragma mark Memory

- (void)handleMemoryWarning {
	NSLog(@"WDLSingletonImageCache: received memory warning");
	WDLSingletonImageCache *sharedImageCacheInstance = [WDLSingletonImageCache sharedImageCacheInstance];
	[sharedImageCacheInstance.sharedImageCache removeAllObjects];
}

- (void) dealloc {
	[imageLoadQueue cancelAllOperations];	
	[imageLoadQueue release];
	[sharedImageCache release];
	[remoteImageDelegates release];
	[super dealloc];
}

#pragma -
#pragma mark Class methods

+ (WDLSingletonImageCache *) sharedImageCacheInstance {
	static WDLSingletonImageCache *sharedImageCacheInstance;
	
	@synchronized([WDLSingletonImageCache class]) {
		if (!sharedImageCacheInstance) {
			sharedImageCacheInstance = [[WDLSingletonImageCache alloc] init];
			[[NSNotificationCenter defaultCenter] addObserver:sharedImageCacheInstance
													 selector:@selector(handleMemoryWarning) 
														 name:UIApplicationDidReceiveMemoryWarningNotification
													   object:nil];
		}
	}
	
	return sharedImageCacheInstance;
}

+ (WDLCachedImageData *)imageCacheForURLString:(NSString *)URLString
{
	WDLCachedImageData *imageData;
	@synchronized([WDLSingletonImageCache class]){
		WDLSingletonImageCache *sharedImageCacheInstance = [WDLSingletonImageCache sharedImageCacheInstance];
		imageData = [sharedImageCacheInstance.sharedImageCache valueForKey:URLString];
		if(!imageData){
			// Check the file system
			NSMutableData *urlData = [WDLSingletonImageCache imageDataForURLString:URLString];
			// If it's there, save it to memory
			if(urlData){ 
				imageData = [[WDLCachedImageData alloc] initWithURLString:URLString];
				imageData.imageData = urlData;
				[WDLSingletonImageCache setImageData:imageData];
				[imageData release];
			}
		}	
	}
	return imageData;
}

+ (void)setImageData:(WDLCachedImageData *)cachedData
{
	@synchronized([WDLSingletonImageCache class]){
		WDLSingletonImageCache *sharedImageCacheInstance = [WDLSingletonImageCache sharedImageCacheInstance];
		[sharedImageCacheInstance.sharedImageCache setValue:cachedData forKey:cachedData.URLString];
		NSArray *delegates = [sharedImageCacheInstance.remoteImageDelegates valueForKey:cachedData.URLString]; 
		if(delegates){
			// Inform any delegate that was watching this image that it has loaded
			for(NSObject <WDLRemoteImageLoaderDelegate> * delegate in delegates){
				// This needs to be done on the main thread, because a WDLImageLoadOperation 
				// might call setImageData: from it's own thread.
				[delegate performSelectorOnMainThread:@selector(imageLoadedAndCached:) 
										   withObject:cachedData 
										waitUntilDone:NO];
			}
			// Remove the delegates from the dictionary
			[sharedImageCacheInstance.remoteImageDelegates removeObjectForKey:cachedData.URLString];
		}
	}
}

+ (void)imageFailedToLoadForURL:(NSURL *)imageURL
{
	@synchronized([WDLSingletonImageCache class]){
		WDLSingletonImageCache *sharedImageCacheInstance = [WDLSingletonImageCache sharedImageCacheInstance];
		NSString *urlString = [imageURL absoluteString];
		NSArray *delegates = [sharedImageCacheInstance.remoteImageDelegates valueForKey:urlString]; 
		if(delegates){
			// Inform any delegate that was watching this image that it has loaded
			for(NSObject <WDLRemoteImageLoaderDelegate> * delegate in delegates){
				[delegate performSelectorOnMainThread:@selector(imageFailedToLoadForURL:) 
										   withObject:imageURL 
										waitUntilDone:NO];
			}
			// Remove the delegates from the dictionary
			[sharedImageCacheInstance.remoteImageDelegates removeObjectForKey:urlString];
		}
	}
}

// This will simply load an image and store it in the cache for future use.
// If the image is already cached, it will not load it again.
// Set willBeDisplayed to YES if this is loaded into a view. 
// Otherwise the image will be saved to disk.
+ (void)loadImageForURL:(NSURL *)imageURL 
			forDelegate:(NSObject <WDLRemoteImageLoaderDelegate> *)delegate
		willBeDisplayed:(BOOL)isDisplayed
{
	// We're just handing this down to the singleton instance
	WDLSingletonImageCache *sharedImageCacheInstance = [WDLSingletonImageCache sharedImageCacheInstance];
	[sharedImageCacheInstance loadImageForURL:imageURL forDelegate:delegate willBeDisplayed:isDisplayed];
}

+ (NSData *)imageDataForURLString:(NSString *)URLString
{
	NSData *imageData;
	@synchronized([WDLSingletonImageCache class]){
		NSString *escapedURLString = [URLString stringWithPercentEscape];
		
		// Find the file
		NSString *filePath = [[self cacheDirectory] stringByAppendingPathComponent:escapedURLString];

		imageData = [NSData dataWithContentsOfFile:filePath];
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
	}
	return imageData;
}

+ (void)saveImageData:(NSData *)imageData fromURLString:(NSString *)URLString
{
	@synchronized([WDLSingletonImageCache class]){
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
}

+ (void)moveDataFromMemoryToDiskForImageAtURLString:(NSString *)URLString
{
	@synchronized([WDLSingletonImageCache class]){
		WDLSingletonImageCache *sharedImageCacheInstance = [WDLSingletonImageCache sharedImageCacheInstance];
		WDLCachedImageData *cachedData = [sharedImageCacheInstance.sharedImageCache valueForKey:URLString];
		if(cachedData){		
			//NSLog(@"Moving image from memory to disk at URL: %@", URLString);
			[self saveImageData:cachedData.imageData fromURLString:URLString];
			[sharedImageCacheInstance.sharedImageCache removeObjectForKey:URLString];
		}						 
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
	// Clear the in-memory cache
	WDLSingletonImageCache *sharedImageCacheInstance = [WDLSingletonImageCache sharedImageCacheInstance];
	[sharedImageCacheInstance.sharedImageCache removeAllObjects];

	// Clear the disk cache
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *fsError;
	BOOL success = [fileManager removeItemAtPath:[self cacheDirectory] error:&fsError];
	if(!success){
		NSLog(@"ERROR clearing image cache: %@", fsError);
	}
	return success;
}

@end