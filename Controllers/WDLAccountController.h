//
//  WDLAccountController.h
//  tap
//
//  Created by William Lindmeier on 10/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDLAccountController : NSObject {
	NSString *username;
	NSString *password;
}

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

+ (BOOL)accountEnabled;
+ (void)setAccountEnabled:(BOOL)enabled;
+ (void)setUsername:(NSString *)aUsername password:(NSString *)aPassword;
+ (id *)sharedInstance;
+ (NSString *)keyEnabled;
+ (NSString *)keyUsername;
+ (NSString *)keyPassword;

@end
