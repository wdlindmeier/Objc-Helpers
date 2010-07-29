//
//  NSEnumerable+Functional.m
//  NavigationProto
//
//  Created by Bill Lindmeier on 7/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSEnumerable+Functional.h"

@implementation NSSet(Functional)

- (NSSet *)setByMappingWithBlock:(id (^)(id obj))block omitNils:(BOOL)omitNils
{
	NSMutableArray *collection = [NSMutableArray arrayWithCapacity:[self count]];
	for(id obj in self){
		id ret = block(obj);		
		if(ret || !omitNils) [collection addObject:ret];
	}
	return [NSSet setWithArray:collection];
}

- (NSArray *)sortedArrayReversing:(BOOL)isReversed withBlock:(id (^)(id obj))block
{
	return [[self allObjects] sortedArrayReversing:isReversed withBlock:block];
}

@end


@implementation NSArray(Functional)

- (NSArray *)arrayByMapingWithBlock:(id (^)(id obj))block omitNils:(BOOL)omitNils
{
	NSMutableArray *collection = [NSMutableArray arrayWithCapacity:[self count]];
	for(id obj in self){
		id ret = block(obj);		
		if(ret || !omitNils) [collection addObject:ret];
	}
	return [NSArray arrayWithArray:collection];
}

- (NSArray *)sortedArrayReversing:(BOOL)isReversed withBlock:(id (^)(id obj))block
{
	NSArray *ret = [self sortedArrayUsingComparator:^(id obj1, id obj2) {
		
		id val1 = block(obj1);
		id val2 = block(obj2);
		NSComparisonResult result = [val1 compare:val2];
		if(isReversed) result *= -1;
		return result;

	}];
	
	return ret;	
}

@end