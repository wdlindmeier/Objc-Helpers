//
//  WDLRemoteImageController.m
//  ImageUploader
//
//  Created by Bill Lindmeier on 1/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WDLRemoteImageController.h"

#define kImageDelegateHandler				@"delegateHandler"
#define kImageDelegateSuccessSelectorName	@"successSelector"
#define kImageDelegateFailSelectorName		@"failedSelector"

@implementation WDLRemoteImageController

#pragma mark init 
- (id)init
{
	if(self = [super init]){
		imageObservers = [[NSMutableDictionary alloc] init];
	}
	
	return self;	
}

#pragma mark WDLRemoteImageLoader

// The uploadRequest might have an image URL for the referrer thumbnail. 
// When this image is needed, call this method to load it and respond to the 
// WDLRemoteImageHandler when it's complete. It might already be loaded,
// in which case we immediately hand it off.

- (void)loadImageFromURL:(NSURL *)imageURL 
			 forDelegate:(NSObject *)imageHandler 
	 withSuccessSelector:(SEL)successSelector 
		  failedSelector:(SEL)failedSelector;
{
	// Since multiple threads will be accessing data in imageObservers,
	// and we're relying on that info for consistency, we need to synchronize any code
	// that accesses it.
	@synchronized(self){
		NSDictionary *delegateInfo = [NSDictionary dictionaryWithObjectsAndKeys:
									 imageHandler, kImageDelegateHandler,
									 NSStringFromSelector(successSelector), kImageDelegateSuccessSelectorName,
									 failedSelector ? NSStringFromSelector(failedSelector) : @"", kImageDelegateFailSelectorName,
									 nil];
		NSString *urlString = [imageURL absoluteString];
		NSMutableArray *urlObservers = [imageObservers objectForKey:urlString];
		if(!urlObservers){
			urlObservers = [NSMutableArray array];
			[imageObservers setObject:urlObservers forKey:urlString];
			// We only need to fire off the loader when the first observer registers.
			// We don't want multiple loaders fetching the same file.
			WDLWebImageLoader *imageLoader = [[WDLWebImageLoader alloc] init];
			imageLoader.delegate = self;
			[imageLoader loadImageFromURL:imageURL];			
		}
		[urlObservers addObject:delegateInfo];

	}
}

#pragma mark WDLWebImageLoaderDelegate

- (void)webImageLoader:(WDLWebImageLoader *)loader failedToLoadWithError:(NSString *)errorMessage
{	
	NSLog(@"failed to load %@", loader.imageURL);
	@synchronized(self){
		NSString *urlString = [loader.imageURL absoluteString];
		NSMutableArray *urlObservers = [imageObservers objectForKey:urlString];	
		for(NSDictionary *observerInfo in urlObservers){
			NSObject *observer = [observerInfo objectForKey:kImageDelegateHandler];
			NSString *failedSelectorName = [observerInfo objectForKey:kImageDelegateFailSelectorName];
			if(![failedSelectorName isEmpty]){
				SEL failedSelector = NSSelectorFromString(failedSelectorName);
				[observer performSelector:failedSelector withObject:errorMessage];
			}
		}
		// Release all of the observers
		[imageObservers removeObjectForKey:urlString];
		[loader release];
	}
}

- (void)webImageLoader:(WDLWebImageLoader *)loader didLoadImage:(UIImage *)image
{
	NSLog(@"loaded %@", loader.imageURL);
	@synchronized(self){
		NSString *urlString = [loader.imageURL absoluteString];
		NSMutableArray *urlObservers = [imageObservers objectForKey:urlString];	
		for(NSDictionary *observerInfo in urlObservers){
			NSObject *observer = [observerInfo objectForKey:kImageDelegateHandler];
			NSString *successSelectorName = [observerInfo objectForKey:kImageDelegateSuccessSelectorName];
			SEL successSelector = NSSelectorFromString(successSelectorName);
			[observer performSelector:successSelector withObject:image];
		}
		// Release all of the observers
		[imageObservers removeObjectForKey:urlString];
		[loader release];
	}
}

#pragma mark Memory 

- (void)dealloc
{
	[imageObservers release];
	[super dealloc];
}

@end
