//
//  WDLRemoteImageController.h
//  ImageUploader
//
//  Created by Bill Lindmeier on 1/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WDLWebImageLoader.h"

@interface WDLRemoteImageController : NSObject <WDLWebImageLoaderDelegate> {
	// Dictionary of objects listening to an image selector
	NSMutableDictionary *imageObservers;
}

- (void)loadImageFromURL:(NSURL *)imageURL 
			 forDelegate:(NSObject *)imageHandler 
	 withSuccessSelector:(SEL)successSelector 
		  failedSelector:(SEL)failedSelector;

@end
