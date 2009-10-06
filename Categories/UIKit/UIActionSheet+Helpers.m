//
//  UIActionSheet+Helpers.m
//  Chaucer
//
//  Created by William Lindmeier on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIActionSheet+Helpers.h"


@implementation UIActionSheet(Helpers)

- (void)disableButtonWithTag:(NSInteger)index
{
	UIButton *disabledButton = (UIButton *)[self viewWithTag:index];
	disabledButton.enabled = NO;
}

@end
