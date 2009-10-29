//
//  UIViewController+Helpers.m
//  tap
//
//  Created by William Lindmeier on 10/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+Helpers.h"


@implementation UIViewController(Helpers)

- (void)resignCurrentFirstResponder
{
	UIResponder *firstResponder = [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(firstResponder)];
	[firstResponder resignFirstResponder];
}

@end