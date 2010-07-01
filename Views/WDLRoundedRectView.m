//
//  WDLRoundedRectView.m
//  TweetCast
//
//  Created by Bill Lindmeier on 6/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WDLRoundedRectView.h"

@interface WDLRoundedRectView()

- (void)defineDefaults;
- (CGPathRef)newPathForRoundedRect:(CGRect)rect radius:(CGFloat)radius;

@end



@implementation WDLRoundedRectView

@synthesize colorBackground, colorStroke, radius, strokeWeight;

#pragma mark -
#pragma mark Init

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		[self defineDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if(self = [super initWithCoder:aDecoder]){
		[self defineDefaults];
	}
	return self;
}

- (void)defineDefaults
{
	self.colorBackground = [UIColor blackColor];
	self.colorStroke = [UIColor whiteColor];
	self.radius = 5.0;
	self.strokeWeight = 2.0;	
}

#pragma mark -
#pragma mark Drawing

- (void) drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGRect frame = self.bounds;
	
	CGPathRef roundedRectPath = [self newPathForRoundedRect:frame radius:self.radius];
	
	//[[UIColor blueColor] set];
	[self.colorBackground set];

	// Background
	CGContextAddPath(ctx, roundedRectPath);
	CGContextFillPath(ctx);
	
	// Stroke
	CGContextAddPath(ctx, roundedRectPath);
	CGContextSetLineWidth(ctx, self.strokeWeight);
	CGContextSetStrokeColor(ctx, CGColorGetComponents(self.colorStroke.CGColor));
	CGContextStrokePath(ctx);
	
	CGPathRelease(roundedRectPath);
}

- (CGPathRef) newPathForRoundedRect:(CGRect)rect radius:(CGFloat)aRadius
{
	CGMutablePathRef retPath = CGPathCreateMutable();
	
	CGRect innerRect = CGRectInset(rect, aRadius, aRadius);
	
	CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
	CGFloat outside_right = rect.origin.x + rect.size.width;
	CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height;
	CGFloat outside_bottom = rect.origin.y + rect.size.height;
	
	CGFloat inside_top = innerRect.origin.y;
	CGFloat outside_top = rect.origin.y;
	CGFloat outside_left = rect.origin.x;
	
	CGPathMoveToPoint(retPath, NULL, innerRect.origin.x, outside_top);
	
	CGPathAddLineToPoint(retPath, NULL, inside_right, outside_top);
	CGPathAddArcToPoint(retPath, NULL, outside_right, outside_top, outside_right, inside_top, aRadius);	
	CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, aRadius);
	
	CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, aRadius);
	CGPathAddLineToPoint(retPath, NULL, outside_left, inside_top);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_top, innerRect.origin.x, outside_top, aRadius);
	
	CGPathCloseSubpath(retPath);
	
	return retPath;
}

#pragma mark -
#pragma mark Memory 

- (void)dealloc {
	self.colorBackground = nil;
	self.colorStroke = nil;
    [super dealloc];
}


@end
