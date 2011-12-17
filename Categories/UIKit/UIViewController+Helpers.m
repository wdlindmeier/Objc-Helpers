//
//  UIViewController+Helpers.m
//  tap
//
//  Created by William Lindmeier on 10/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+Helpers.h"


@implementation UIViewController(Helpers)

// This doesn't technically have to be a picker view,
// but that's what it's designed for
- (void)showPickerView:(UIView *)pickerView
{
	UIView *parentWindow = [UIApplication sharedApplication].keyWindow;
	CGRect pickerFrame = pickerView.bounds;
	if(!pickerView.superview){
		pickerView.frame = CGRectMake(0.0, parentWindow.frame.size.height,
									  pickerFrame.size.width, pickerFrame.size.height);
		[parentWindow addSubview:pickerView];
	}
	[UIView beginAnimations:@"showPickerView" context:pickerView];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];


	pickerView.frame = CGRectMake(0.0, parentWindow.frame.size.height - pickerFrame.size.height,
								  pickerFrame.size.width, pickerFrame.size.height);

	[UIView commitAnimations];
}

// This doesn't technically have to be a picker view,
// but that's what it's designed for
- (void)hidePickerView:(UIView *)pickerView
{
	CGRect pickerFrame = pickerView.bounds;

	UIView *parentWindow = [UIApplication sharedApplication].keyWindow;

	[UIView beginAnimations:@"hidePickerView" context:pickerView];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];


	pickerView.frame = CGRectMake(0.0, parentWindow.frame.size.height,
								  pickerFrame.size.width, pickerFrame.size.height);

	[UIView commitAnimations];

}

- (BOOL)isVisible
{
	return !!self.view.window;
}

@end
