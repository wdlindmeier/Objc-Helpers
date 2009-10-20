//
//  UIImage+INResizeImageAllocator.h
//  Geotag
//
//  Created by William Lindmeier on 4/16/09.
//  Copyright 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

// This adds a method to UIImage that allows us to scale

@interface UIImage (INResizeImageAllocator)

	- (UIImage*)scaleImageToSize:(CGSize)newSize;
	- (UIImage*)fillImageToSize:(CGSize)newSize;
	- (UIImage *)cropImageToRect:(CGRect)cropRect;
	- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox;
	- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize;

	+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
	+ (UIImage*)imageWithImage:(UIImage*)image filledToSize:(CGSize)newSize;
	+ (UIImage *)scaleImage:(UIImage *)image withRatio:(float)scaleRatio;


@end
