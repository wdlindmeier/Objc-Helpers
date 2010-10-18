//
//  WDLAccountController.m
//  tap
//
//  Created by William Lindmeier on 10/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WDLAccountController.h"

@implementation WDLAccountController

@dynamic username, password;

#pragma mark Accessors 

- (NSString *)username
{
	if(username == nil){
		username = [[NSUserDefaults standardUserDefaults] valueForKey:[[self class] keyUsername]];
	}
	return username;
}

- (void)setUsername:(NSString *)aUsername
{	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	if([aUsername isNotBlank]){
		NSString *newUsername = [aUsername copy];
		[username release];
		username = newUsername;
		[prefs setValue:username forKey:[[self class] keyUsername]];
	}else{
		[username release];
		username = nil;
		[prefs removeObjectForKey:[[self class] keyUsername]];
	}
	[prefs synchronize];
}

- (NSString *)password
{
	if(password == nil){
		password = [[NSUserDefaults standardUserDefaults] valueForKey:[[self class] keyPassword]];
	}
	return password;
}

- (void)setPassword:(NSString *)aPassword
{	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	if([aPassword isNotBlank]){
		NSString *newPassword = [aPassword copy];
		[password release];
		password = newPassword;
		[prefs setValue:password forKey:[[self class] keyPassword]];
	}else{
		[password release];
		password = nil;
		[prefs removeObjectForKey:[[self class] keyPassword]];
	}	
	[prefs synchronize];
}

#pragma mark Memory

- (void)dealloc
{
	[username release];
	[password release];
	[super dealloc];	
}

#pragma mark Class methods

// NOTE: Don't create the shared instance in the super controller.
// It's stored in a static variable and therefore should be defined in the subclass
+ (id *)sharedInstance
{	
	return nil;	
}

+ (void)setUsername:(NSString *)aUsername password:(NSString *)aPassword
{
	((WDLAccountController *)[self sharedInstance]).username = aUsername;
	((WDLAccountController *)[self sharedInstance]).password = aPassword;
}

+ (BOOL)accountEnabled
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:[self keyEnabled]];
}

+ (void)setAccountEnabled:(BOOL)enabled
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	if(!enabled){
		((WDLAccountController *)[self sharedInstance]).username = nil;
		((WDLAccountController *)[self sharedInstance]).password = nil;
	}
	[prefs setBool:enabled forKey:[self keyEnabled]];
	[prefs synchronize];
}

+ (NSString *)keyEnabled{ return @"accountEnabled"; }
+ (NSString *)keyUsername{ return @"accountUsername"; }
+ (NSString *)keyPassword{ return @"accountPassword"; }

@end
