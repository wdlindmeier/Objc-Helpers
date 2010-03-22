//
//  WDLWebImageLoader.h
//  Geotag
//
//  Created by William Lindmeier on 4/28/09.
//  Copyright 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDLWebImageLoader;

@protocol WDLWebImageLoaderDelegate

@required 

- (void)webImageLoader:(WDLWebImageLoader *)loader failedToLoadWithError:(NSString *)errorMessage;
- (void)webImageLoader:(WDLWebImageLoader *)loader didLoadImage:(UIImage *)image;

@end

@interface WDLWebImageLoader : NSObject {
	id <WDLWebImageLoaderDelegate> delegate;
	NSURL *imageURL;
	BOOL isLoading;
}

-(void)loadImageFromURL:(NSURL *)url;

@property(nonatomic, assign) id <WDLWebImageLoaderDelegate> delegate;
@property(nonatomic, retain) NSURL *imageURL;

@end
