//
//  UIImage+INResizeImageAllocator.h
//  Geotag
//
//  Created by William Lindmeier on 4/16/09.
//  Copyright 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

// This adds a method to UIImage that allows us to scale

@interface UIImage (Helpers)

//http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/

- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
		  transparentBorder:(NSUInteger)borderSize
			   cornerRadius:(NSUInteger)cornerRadius
	   interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
	 interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
								  bounds:(CGSize)bounds
					interpolationQuality:(CGInterpolationQuality)quality;
// Rounded Corner
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;
// Alpha
- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;

@end
