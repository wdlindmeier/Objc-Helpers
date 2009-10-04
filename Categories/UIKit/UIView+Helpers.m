//
//  UIView+Helpers.m
//  tap
//
//  Created by William Lindmeier on 8/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIView+Helpers.h"


@implementation UIView(Helpers)

- (UIImage *)renderedAsImage
{
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return viewImage;
}

- (CGPoint)positionWithinView:(UIView *)parentView
{
	CGPoint position = CGPointMake(0.0, 0.0);
	if([self isDescendantOfView:parentView]){
		UIView *parent = self;		
		while(parent != parentView){
			position = CGPointMake(position.x + parent.frame.origin.x, position.y + parent.frame.origin.y);
			parent = parent.superview;
		}
	}
	return position;
}

@end