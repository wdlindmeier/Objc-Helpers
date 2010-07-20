//
//  NSArray+Functional.h
//  tap
//
//  Created by William Lindmeier on 5/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (Functional)

- (NSArray *)filterUsingSelector:(SEL)aSelector, ...; // selector returning BOOL
- (NSArray *)mapUsingSelector:(SEL)aSelector, ...; // selector returning id
- (id)reduceUsingSelector:(SEL)aSelector; // selector returning id
- (NSArray *)reversedArray;

@end