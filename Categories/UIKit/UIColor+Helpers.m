//
//  UIColor+Helpers.m
//  Chaucer
//
//  Created by William Lindmeier on 9/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIColor+Helpers.h"

#define DEFAULT_VOID_COLOR	[UIColor clearColor];

@implementation UIColor(Helpers)

+ (UIColor *)colorWithHexString: (NSString *) stringToConvert
{
	NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

	// String should be 6 or 8 characters
	if ([cString length] < 6) return DEFAULT_VOID_COLOR;

	// strip 0X if it appears
	if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];

	if ([cString length] != 6) return DEFAULT_VOID_COLOR;

	// Separate into r, g, b substrings
	NSRange range;
	range.location = 0;
	range.length = 2;
	NSString *rString = [cString substringWithRange:range];

	range.location = 2;
	NSString *gString = [cString substringWithRange:range];

	range.location = 4;
	NSString *bString = [cString substringWithRange:range];

	// Scan values
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];

	return [UIColor colorWithRed:((float) r / 255.0f)
						   green:((float) g / 255.0f)
							blue:((float) b / 255.0f)
						   alpha:1.0f];
}

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
	CGFloat redComp = red / 255.f;
	CGFloat greenComp = green / 255.f;
	CGFloat blueComp = blue / 255.f;
	
	return [UIColor colorWithRed:redComp green:greenComp blue:blueComp alpha:1.f];
}

@end