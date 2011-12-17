//
//  UIImage+INResizeImageAllocator.m
//  Geotag
//
//  Created by William Lindmeier on 4/16/09.
//  Copyright 2009. All rights reserved.
//

#import "UIImage+INResizeImageAllocator.h"

@implementation UIImage (INResizeImageAllocator)

#pragma mark Instance methods

- (UIImage *)scaleImageToSize:(CGSize)size {
	return [UIImage imageWithImage:self scaledToSize:size];
}

- (UIImage *)cropImageToRect:(CGRect)cropRect {
	// Begin the drawing (again)
	UIGraphicsBeginImageContext(cropRect.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();

	// Tanslate and scale upside-down to compensate for Quartz's inverted coordinate system
	CGContextTranslateCTM(ctx, 0.0, cropRect.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);

	// Draw view into context
	CGRect drawRect = CGRectMake(-cropRect.origin.x, cropRect.origin.y - (self.size.height - cropRect.size.height) , self.size.width, self.size.height);
	CGContextDrawImage(ctx, drawRect, self.CGImage);

	// Create the new UIImage from the context
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

	// End the drawing
	UIGraphicsEndImageContext();

	return newImage;
}

- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox {
	// Make the shortest side be equivalent to the cropping box.
	CGFloat newHeight, newWidth;
	if (self.size.width < self.size.height) {
		newWidth = croppingBox.width;
		newHeight = (self.size.height / self.size.width) * croppingBox.width;
	} else {
		newHeight = croppingBox.height;
		newWidth = (self.size.width / self.size.height) *croppingBox.height;
	}

	return CGSizeMake(newWidth, newHeight);
}

- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize {
	UIImage *scaledImage = [self scaleImageToSize:[self calculateNewSizeForCroppingBox:cropSize]];
	return [scaledImage cropImageToRect:CGRectMake((scaledImage.size.width-cropSize.width)/2, (scaledImage.size.height-cropSize.height)/2, cropSize.width, cropSize.height)];
}

- (UIImage*)fillImageToSize:(CGSize)newSize
{
	return [UIImage imageWithImage:self filledToSize:newSize];
}


#pragma mark Class methods

// This scales the image so the entire thing can be seen within the box, which leaves some margins
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
	float widthRatio = newSize.width / image.size.width;
	float heightRatio = newSize.height / image.size.height;
	float scaleRatio = heightRatio > widthRatio ? widthRatio : heightRatio;
	return [self scaleImage:image withRatio:scaleRatio];
}

// This scales the image so the whole box is filled, which clips some original image data
+ (UIImage*)imageWithImage:(UIImage*)image filledToSize:(CGSize)newSize;
{
	float widthRatio = newSize.width / image.size.width;
	float heightRatio = newSize.height / image.size.height;
	float scaleRatio = heightRatio > widthRatio ? heightRatio : widthRatio;
	return [self scaleImage:image withRatio:scaleRatio];
}

+ (UIImage *)scaleImage:(UIImage *)image withRatio:(float)scaleRatio
{
	CGSize newSize = CGSizeMake(ceil(image.size.width * scaleRatio), ceil(image.size.height * scaleRatio));
	UIGraphicsBeginImageContext( newSize );
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end