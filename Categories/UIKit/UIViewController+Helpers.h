//
//  UIViewController+Helpers.h
//  tap
//
//  Created by William Lindmeier on 10/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIViewController(Helpers)

- (void)showPickerView:(UIView *)pickerView;
- (void)hidePickerView:(UIView *)pickerView;
- (BOOL)isVisible;

@end
