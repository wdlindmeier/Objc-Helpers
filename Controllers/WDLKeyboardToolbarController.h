//
//  WDLKeyboardToolbarController.h
//  Mobile
//
//  Created by William Lindmeier on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WDLKeyboardToolbarDelegate;

@interface WDLKeyboardToolbarController : UIViewController {
	
	UIToolbar *toolbar;
	UIBarItem *buttonDone;
	UISegmentedControl *buttonPrevNext;
	UIViewController <WDLKeyboardToolbarDelegate> * delegate;	
	UITextField *textFieldAssumeFirstResponder;
	
	BOOL keyboardIsVisible;
	BOOL toolbarIsAnimating;
	
}

@property (nonatomic, retain) IBOutlet UIBarItem *buttonDone;
@property (nonatomic, retain) IBOutlet UISegmentedControl *buttonPrevNext;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, assign) UIViewController <WDLKeyboardToolbarDelegate> * delegate;

- (IBAction)buttonDonePressed:(id)sender;
- (IBAction)buttonPrevNextPressed:(id)sender;

- (void)hideKeyboard;
- (void)animateToolbarToFrame:(CGRect)inputFrame named:(NSString *)animationID;
- (BOOL)isKeyboardVisible;

@end

@protocol WDLKeyboardToolbarDelegate

@optional

- (void)keyboardToolbarButtonDonePressed:(id)sender;
- (void)keyboardToolbarButtonPreviousPressed:(id)sender;
- (void)keyboardToolbarButtonNextPressed:(id)sender;
- (void)keyboardWillAppear:(CGRect)bounds;
- (void)keyboardWillHide:(CGRect)bounds;

@end