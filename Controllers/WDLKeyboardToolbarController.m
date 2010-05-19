//
//  WDLKeyboardToolbarController.m
//  Mobile
//
//  Created by William Lindmeier on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WDLKeyboardToolbarController.h"

@interface WDLKeyboardToolbarController()

- (void)setPreviousNextVisibility;

@end


@implementation WDLKeyboardToolbarController

@synthesize toolbar, buttonDone, buttonPrevNext, delegate;

#pragma mark Init 

// NOTE: This controller is designed to work with a NIB so the interface is customizable 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
		[nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];				
    }
    return self;
}

#pragma mark Accessors 

- (void)setDelegate:(UIViewController <WDLKeyboardToolbarDelegate> *)aController
{	
	delegate = aController;
	[self setPreviousNextVisibility];
}

- (void)setPreviousNextVisibility
{
	if(delegate){ 
		// We'll hide the prev/next buttons if the delegate doesn't respond to their inputs.
		// NOTE: buttonPrevNext might not exist if it's not in the user's NIB
		BOOL showPrevNext = ([delegate respondsToSelector:@selector(keyboardToolbarButtonPreviousPressed:)] ||
							 [delegate respondsToSelector:@selector(keyboardToolbarButtonNextPressed:)]);
		self.buttonPrevNext.hidden = !showPrevNext;
	}	
}

#pragma mark View 

- (void)viewDidLoad
{	
	[super viewDidLoad];
	
	[self setPreviousNextVisibility];
	
	// We add a text field to the view so it can assume the first responder 
	// and then resign it (thus hiding the keyboard without having to track the first responder)
	textFieldAssumeFirstResponder = [[UITextField alloc] initWithFrame:CGRectZero];
	textFieldAssumeFirstResponder.hidden = YES;
	[self.view addSubview:textFieldAssumeFirstResponder];
	
	// Add my view to the bottom of the main window
	UIView *mainWindow = [[UIApplication sharedApplication] keyWindow];
	CGRect windowFrame = mainWindow.frame;
	CGSize mySize = self.view.frame.size;
	self.view.frame = CGRectMake(0.0, windowFrame.size.height, mySize.width, mySize.height);
	[mainWindow addSubview:self.view];	
	
}

#pragma mark Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
	if(self.delegate){
		UIView *mainWindow = [[UIApplication sharedApplication] keyWindow];
		CGRect windowFrame = mainWindow.frame;

		CGRect r = self.view.frame, t;
		[[notification.userInfo valueForKey:UIKeyboardBoundsUserInfoKey] getValue:&t];
		r.origin.y = windowFrame.size.height - (t.size.height + r.size.height);
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		
		self.view.frame = r;
		
		[UIView commitAnimations];
	}	
}

- (void)keyboardWillHide:(NSNotification *)notification
{	
	if(self.delegate){		
		UIView *mainWindow = [[UIApplication sharedApplication] keyWindow];
		CGRect windowFrame = mainWindow.frame;

		CGRect r = self.view.frame;
		r.origin.y = windowFrame.size.height;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		
		self.view.frame = r;
		
		[UIView commitAnimations];
	}	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark IBActions 

- (IBAction)buttonDonePressed:(id)sender
{
	[textFieldAssumeFirstResponder becomeFirstResponder];
	[textFieldAssumeFirstResponder resignFirstResponder];
	if(self.delegate && [self.delegate respondsToSelector:@selector(keyboardToolbarButtonDonePressed:)]){
		[self.delegate keyboardToolbarButtonDonePressed:sender];
	}
}

#define kSegmentIndexPrevious	0
#define kSegmentIndexNext		1

- (IBAction)buttonPrevNextPressed:(id)sender
{
	if(self.delegate){ 
		switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
			case kSegmentIndexPrevious:
				if([self.delegate respondsToSelector:@selector(keyboardToolbarButtonPreviousPressed:)]){
					[self.delegate keyboardToolbarButtonPreviousPressed:sender];
				}				
				break;
			case kSegmentIndexNext:	
				if([self.delegate respondsToSelector:@selector(keyboardToolbarButtonNextPressed:)]){
					[self.delegate keyboardToolbarButtonNextPressed:sender];
				}
				break;
		}		
	}
}

#pragma mark Memory

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.toolbar = nil;
	self.buttonDone = nil;
	self.buttonPrevNext = nil;
	[self.view removeFromSuperview];
}

- (void)dealloc {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	[self viewDidUnload];
	self.delegate = nil;
	[textFieldAssumeFirstResponder release];
    [super dealloc];
}


@end