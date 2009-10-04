//
//  NSString+Helpers.m
//  tap
//
//  Created by William Lindmeier on 6/10/09.
//  Copyright 2009. All rights reserved.
//

#import "NSString+Helpers.h"


@implementation NSString (Helpers)

- (BOOL)containsString:(NSString *)matchString
{  
     NSPredicate *containPred = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", matchString];  
     return [containPred evaluateWithObject:self];  
}  

- (BOOL)isEmpty
{
	// Strips the string and compares it against an empty string
	// NOTE: This does not strip other whitespace characters such as newlines
	return [[self stringByReplacingOccurrencesOfString:@" " withString:@""] isEqual:@""];
}

+ (NSString *)setterFromGetter:(NSString *)getterName
{
	NSMutableString *capitalizedGetter = [getterName mutableCopy];	
	[capitalizedGetter replaceCharactersInRange:NSMakeRange(0, 1)
									 withString:[[getterName substringToIndex:1] capitalizedString]];
	NSString *setter = [NSString stringWithFormat:@"set%@:", capitalizedGetter];
	[capitalizedGetter release];
	return setter;
}

@end
