//
//  CachedImageData.h
//  Native
//
//  Created by Bill Lindmeier on 4/12/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CachedImageData : NSObject {
	
	NSMutableData *imageData;
	int displayCount;
	NSString *URLString;

}

@property (nonatomic, retain) NSMutableData *imageData;
@property (nonatomic, assign) int displayCount;
@property (nonatomic, retain) NSString *URLString;

- (id)initWithURLString:(NSString *)aURL;// ImageData:(NSMutableData *)data;

@end
