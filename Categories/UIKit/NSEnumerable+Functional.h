//
//  NSEnumerable+Functional.h
//  NavigationProto
//
//  Created by Bill Lindmeier on 7/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSSet(Functional)

- (NSArray *)mapUsingBlock:(id (^)(id obj))block;
- (NSArray *)sortedArrayReversing:(BOOL)isReversed withBlock:(id (^)(id obj))block;

@end


@interface NSArray(Functional)

- (NSArray *)mapUsingBlock:(id (^)(id obj))block;
- (NSArray *)sortedArrayReversing:(BOOL)isReversed withBlock:(id (^)(id obj))block;

@end