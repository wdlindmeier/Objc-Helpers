//
//  UIView+Helpers.h
//  tap
//
//  Created by William Lindmeier on 8/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView(Helpers)

- (UIImage *)renderedAsImage;
- (CGPoint)positionWithinView:(UIView *)parentView;
- (void)removeAllSubviews;

@end

@interface UIScrollView(Helpers)

- (void)growToAccomodateKeyboardBounds:(CGRect)bounds;
- (void)shrinkToReclaimKeyboardBounds:(CGRect)bounds;

@end

