//
//  NSNumber+Helpers.m
//  BN
//
//  Created by William Lindmeier on 7/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSNumber+Helpers.h"

@implementation NSNumber(Helpers)

- (BOOL)isNotBlank
{
	return [self floatValue] != 0.0f;
}

@end
