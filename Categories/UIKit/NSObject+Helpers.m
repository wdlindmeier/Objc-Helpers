//
//  NSObject+Helpers.m
//  tweak
//
//  Created by William Lindmeier on 11/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSObject+Helpers.h"

@implementation NSObject(Helpers)

- (BOOL)isNotBlank
{
	return self != [NSNull null];
}

@end
