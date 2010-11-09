//
//  WDLDropCircle.m
//  BN
//
//  Created by William Lindmeier on 11/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WDLDropCircle.h"


@implementation WDLDropCircle

@synthesize shadowOffset, shadowOpacity, shadowColor, shrinksToBounds;

#pragma mark -
#pragma mark Init 

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

#pragma mark -
#pragma mark Drawing

- (void)layoutSubviews
{
	[super layoutSubviews];
		
	[self.layer setShadowOffset:self.shadowOffset];
	[self.layer setShadowOpacity:self.shadowOpacity];
	[self.layer setShadowColor:self.shadowColor.CGColor];
	
	if(shrinksToBounds){
		CGSize frameSize = self.frame.size;
		float shadowRadius = self.layer.shadowRadius + 2.0; // NOTE: Adding 2, because sometimes the shadow bleeds over
		float x = shadowRadius - shadowOffset.width;
		float y = shadowRadius - shadowOffset.height;

		float minDimension = frameSize.width < frameSize.height ? frameSize.width : frameSize.height;
		float maxOffset = fabs(x) > fabs(y) ? fabs(x) : fabs(y);
		float layerDimension = minDimension - (shadowRadius * 2) - maxOffset;
		
		if(x < 0) x = 0.0;
		if(y < 0) y = 0.0;

		self.layer.bounds = CGRectMake(x, 
									   y, 
									   layerDimension, 
									   layerDimension);
		self.layer.cornerRadius = layerDimension * 0.5;		
	}else{
		CGSize mySize = self.frame.size;
		float maxDimension = mySize.width > mySize.height ? mySize.width : mySize.height;
		self.layer.cornerRadius = maxDimension * 0.5;
	}
}

#pragma mark -
#pragma mark Memory 

- (void)dealloc 
{
	self.shadowOffset = CGSizeZero;
	self.shadowOpacity = 0.0;
	self.shadowColor = nil;
	self.shrinksToBounds = NO;
    [super dealloc];
}

@end
