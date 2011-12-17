//
//  WDLRoundedRectView.h
//  TweetCast
//
//  Created by Bill Lindmeier on 6/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WDLRoundedRectView : UIView {

	UIColor *colorBackground;
	UIColor *colorStroke;
	float radius;
	float strokeWeight;

}

@property (nonatomic, retain) UIColor *colorBackground;
@property (nonatomic, retain) UIColor *colorStroke;
@property (nonatomic, assign) float radius;
@property (nonatomic, assign) float strokeWeight;

@end
