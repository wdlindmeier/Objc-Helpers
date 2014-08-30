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

- (NSString *)camelCaseStringFromUnderscored
{
	NSArray *components = [self componentsSeparatedByString:@"_"];
	NSMutableArray *cappedComponents = [NSMutableArray arrayWithCapacity:[components count]];
	[components enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[cappedComponents addObject:(idx > 0 ? [(NSString *)obj capitalizedString] : obj)];
	}];
	return [cappedComponents componentsJoinedByString:@""];
}

- (NSString *)titleizedStringFromCamelCase
{
	return [[self camelCaseComponents] componentsJoinedByString:@" "];
}

- (NSString *)underscoredStringFromCamelCase
{
	return [[[self titleizedStringFromCamelCase] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
}

- (NSString*)stringWithPercentEscape {
	NSMutableString *escaped = [[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] mutableCopy];
	[escaped replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"," withString:@"%2C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@":" withString:@"%3A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@";" withString:@"%3B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\t" withString:@"%09" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"#" withString:@"%23" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"<" withString:@"%3C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@">" withString:@"%3E" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\"" withString:@"%22" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\n" withString:@"%0A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];

	return [escaped autorelease];
 //   return [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[self mutableCopy] autorelease], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"),kCFStringEncodingUTF8) autorelease];
}


- (NSString*)stringByUnescapingPercentEscape {
	NSMutableString *unescaped = [[self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] mutableCopy];
	[unescaped replaceOccurrencesOfString:@"%26" withString:@"&" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"%2B" withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"%2C" withString:@"," options:NSCaseInsensitiveSearch range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"%2F" withString:@"/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"%3A" withString:@":" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"%3B" withString:@";" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"%3D" withString:@"=" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"%3F" withString:@"?" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"%40" withString:@"@" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"%20" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"%09" withString:@"\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"%23" withString:@"#" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"%3C" withString:@"<" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"%3E" withString:@">" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"%22" withString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"%0A" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [unescaped length])];

	return [unescaped autorelease];
	//   return [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[self mutableCopy] autorelease], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"),kCFStringEncodingUTF8) autorelease];
}

- (NSString *)normalizedString
{
	NSData *asciiData = [[self lowercaseString] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	return [[[NSString alloc] initWithData:asciiData encoding:NSASCIIStringEncoding] autorelease];
}

- (NSString *)stringByIncrementingCharacters
{
	int lastIndex = [self length] - 1;
	unichar lastChar = [self characterAtIndex:lastIndex];
	unichar chars[] = {lastChar+1};
	return [self stringByReplacingCharactersInRange:NSMakeRange(lastIndex, 1) withString:[NSString stringWithCharacters:chars length:1]];
}

- (NSString *)stringByStrippingString
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)stringByPluralizingString
{
	return [[self stringByReplacingOccurrencesOfString:@"y"
											withString:@"ie"
											   options:0
												 range:NSMakeRange(([self length] - 1), 1)]
			stringByAppendingString:@"s"];
}

- (NSString *)stringByCapitalizingFirstLetter
{
	NSString *firstLetter = [self substringToIndex:1];
	return [self stringByReplacingCharactersInRange:NSMakeRange(0,1)
										 withString:[firstLetter capitalizedString]];
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

+ (NSString *)udid
{
	CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
	CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
	NSString *uuidString = [NSString stringWithString:(NSString*)strRef];
	CFRelease(strRef);
	CFRelease(uuidRef);
	return uuidString;
}

+ (NSString *)currencyStringForNumber:(NSNumber *)amount truncateZeros:(BOOL)truncateZeros
{
	NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
	[currencyStyle setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[currencyStyle setNumberStyle:NSNumberFormatterCurrencyStyle];
	NSString *currencyString = [currencyStyle stringFromNumber:amount];
	if(truncateZeros) currencyString = [currencyString stringByReplacingOccurrencesOfString:@".00" withString:@""];
	[currencyStyle release];
	return currencyString;
}

@end
