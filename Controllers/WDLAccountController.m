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
	if(aUsername && ![aUsername isEmpty]){
		NSString *newUsername = [aUsername copy];
		[username release];
		username = newUsername;
		[[NSUserDefaults standardUserDefaults] setValue:username forKey:[[self class] keyUsername]];
	}else{
		[username release];
		username = nil;
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:[[self class] keyUsername]];
	}
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
	if(aPassword && ![aPassword isEmpty]){
		NSString *newPassword = [aPassword copy];
		[password release];
		password = newPassword;
		[[NSUserDefaults standardUserDefaults] setValue:password forKey:[[self class] keyPassword]];
	}else{
		[password release];
		password = nil;
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:[[self class] keyPassword]];
	}	
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
	[[NSUserDefaults standardUserDefaults] setBool:enabled forKey:[self keyEnabled]];
}

+ (NSString *)keyEnabled{ return @"accountEnabled"; }
+ (NSString *)keyUsername{ return @"accountUsername"; }
+ (NSString *)keyPassword{ return @"accountPassword"; }

@end
