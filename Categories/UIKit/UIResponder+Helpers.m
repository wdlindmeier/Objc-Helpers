//
//  UIResponder+Helpers.m
//  NavigationProto
//
//  Created by Bill Lindmeier on 9/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIResponder+Helpers.h"

@implementation UIResponder(Helpers)

- (BOOL)becomeFirstResponderAndSendNotification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:WLDWillBecomeFirstResponderNotification object:self];
	return [self becomeFirstResponderAndSendNotification];
}

+ (void)setInstancesSendFirstResponderNotifications:(BOOL)shouldSendNotification
{
	static BOOL sendsNotification = NO;
	
	if(shouldSendNotification != sendsNotification){
		[UIResponder swizzleInstanceMethod:@selector(becomeFirstResponder) 
						   withReplacement:@selector(becomeFirstResponderAndSendNotification)];		
		sendsNotification = shouldSendNotification;
	}	
}

@end
