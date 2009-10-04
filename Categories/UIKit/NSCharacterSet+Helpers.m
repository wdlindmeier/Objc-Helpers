//
//  NSCharacterSet+Helpers.m
//  tap
//
//  Created by William Lindmeier on 6/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSCharacterSet+Helpers.h"

static NSCharacterSet *numericCharacterSet;

@implementation NSCharacterSet(Helpers)

+ (NSCharacterSet *)numericCharacterSet{
	if(!numericCharacterSet){
		numericCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
		[numericCharacterSet retain];
	}
	return numericCharacterSet;
}

@end
