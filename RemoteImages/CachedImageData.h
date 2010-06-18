//
//  CachedImageData.h
//  Native
//
//  Created by William Lindmeier on 4/12/10.
//  Copyright 2010 William Lindmeier All rights reserved.
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

- (id)initWithURLString:(NSString *)aURL;

@end
