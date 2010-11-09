//
//  DropCircle.h
//  BN
//
//  Created by William Lindmeier on 11/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WDLDropCircle : UIView {

	CGSize shadowOffset;
	float shadowOpacity;
	UIColor *shadowColor;
	BOOL shrinksToBounds;
	
}

@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) float shadowOpacity;
@property (nonatomic, assign) BOOL shrinksToBounds;
@property (nonatomic, retain) UIColor *shadowColor;

@end
