//
//  WebImageLoader.h
//  Geotag
//
//  Created by William Lindmeier on 4/28/09.
//  Copyright 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebImageLoader;

@protocol WebImageLoaderDelegate

@required 

- (void)webImageLoader:(WebImageLoader *)loader failedToLoadWithError:(NSString *)errorMessage;
- (void)webImageLoader:(WebImageLoader *)loader didLoadImage:(UIImage *)image;

@end

@interface WebImageLoader : NSObject {
	id <WebImageLoaderDelegate> delegate;
	NSString *urlString;
	BOOL isLoading;
}

-(void)loadImageFromURL:(NSString *)imageURLString;

@property(nonatomic, assign) id <WebImageLoaderDelegate> delegate;
@property(nonatomic, readonly) NSString *urlString;

@end
