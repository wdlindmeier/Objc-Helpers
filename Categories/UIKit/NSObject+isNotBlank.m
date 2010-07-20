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

@interface NSArray (isNotBlank)

- (BOOL)isNotBlank
{
	return [self count] > 0;
}

@end

@interface NSSet (isNotBlank)

- (BOOL)isNotBlank
{
	return [self count] > 0;
}

@end

@interface NSDictionary (isNotBlank)

- (BOOL)isNotBlank
{
	return [self count] > 0;
}

@end

@interface NSString (isNotBlank)

- (BOOL)isNotBlank
{
	return ![[self stringByStrippingString] isEqualToString:@""];
}

@end

@interface NSNull(isNotBlank)

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