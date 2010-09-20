//
//  UIResponder+Helpers.h
//  NavigationProto
//
//  Created by Bill Lindmeier on 9/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WLDWillBecomeFirstResponderNotification	@"WLDWillBecomeFirstResponder"

@interface UIResponder(Helpers)

- (BOOL)becomeFirstResponderAndSendNotification;

+ (void)setInstancesSendFirstResponderNotifications:(BOOL)shouldSendNotification;

@end
