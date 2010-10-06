//
//  NSObject+Helpers.m
//  BN
//
//  Created by William Lindmeier on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSObject+Helpers.h"


@implementation NSObject(Helpers)

@dynamic className;

- (NSString *)className
{
	return NSStringFromClass([self class]);
}

@end
