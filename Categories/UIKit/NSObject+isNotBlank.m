//
//  NSObject+isNotBlank.m
//  NavigationProto
//
//  Created by Bill Lindmeier on 7/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSObject+isNotBlank.h"


@implementation NSObject(isNotBlank)

- (BOOL)isNotBlank
{
	return self != [NSNull null];
}

@end

@implementation NSArray (isNotBlank)

- (BOOL)isNotBlank
{
	return [self count] > 0;
}

@end

@implementation NSSet (isNotBlank)

- (BOOL)isNotBlank
{
	return [self count] > 0;
}

@end

@implementation NSDictionary (isNotBlank)

- (BOOL)isNotBlank
{
	return [self count] > 0;
}

@end

@implementation NSString (isNotBlank)

- (BOOL)isNotBlank
{
	return ![[self stringByStrippingString] isEqualToString:@""];
}

@end

@implementation NSNull(isNotBlank)

- (BOOL)isNotBlank
{
	return NO;
}

@end

@implementation NSNumber(isNotBlank)

- (BOOL)isNotBlank
{
	return [self floatValue] != 0.0f;
}

@end