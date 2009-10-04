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

- (UIImage*)scaleImageToSize:(CGSize)newSize
{
	return [UIImage imageWithImage:self scaledToSize:newSize];
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