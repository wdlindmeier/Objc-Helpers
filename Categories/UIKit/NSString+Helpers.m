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

// Strips the string and compares it against an empty string
- (BOOL)isEmpty
{
	// NOTE: This does not strip other whitespace characters such as newlines
	return [[self stringByReplacingOccurrencesOfString:@" " withString:@""] isEqual:@""];
}

// String Transformers

- (NSArray *)camelCaseComponents
{
	// CamelCase components
	NSScanner *nameScanner = [NSScanner scannerWithString:self];
	[nameScanner setCaseSensitive:YES];
	int scanLocation = 0;
	NSMutableArray *nameArray = [NSMutableArray array];
	while(![nameScanner isAtEnd]){
		
		NSMutableArray *tokenArray = [NSMutableArray arrayWithCapacity:2];
		
		NSString *startToken;
		BOOL foundStart = [nameScanner scanCharactersFromSet:[NSCharacterSet uppercaseLetterCharacterSet] intoString:&startToken];
		if(foundStart) [tokenArray addObject:startToken];
		
		NSString *restToken;
		BOOL foundRest = [nameScanner scanUpToCharactersFromSet:[NSCharacterSet uppercaseLetterCharacterSet] intoString:&restToken];
		if(foundRest) [tokenArray addObject:restToken];
		
		if(foundStart || foundRest){ 
			NSString *token = [tokenArray componentsJoinedByString:@""];
			scanLocation += [token length];
			[nameArray addObject:token]; 
			[nameScanner setScanLocation:scanLocation];
		}
	}

	return nameArray;
}

- (NSString *)titleizedStringFromCamelCase
{
	return [[self camelCaseComponents] componentsJoinedByString:@" "];
}

- (NSString *)underscoredStringFromCamelCase
{
	return [[[self titleizedStringFromCamelCase] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
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

+ (NSDictionary *)dictionaryFromQueryParams:(NSString *)paramsString lowercaseKeys:(BOOL)shouldLowercase
{	
	// If the string starts with a ?, lop it off
	NSString *queryString = [paramsString stringByReplacingOccurrencesOfString:@"?" withString:@""];
	
	NSMutableDictionary *options = [NSMutableDictionary dictionary];
	
	NSArray *paramKeyValues = [queryString componentsSeparatedByString:@"&"];		
	
	for(NSString *param in paramKeyValues){
		NSArray *keyValue = [param componentsSeparatedByString:@"="];
		NSString *theKey = [keyValue objectAtIndex:0];
		if(shouldLowercase) theKey = [theKey lowercaseString];
		[options setObject:[keyValue objectAtIndex:1] forKey:theKey];
	}
	
	return options;	
}


@end
