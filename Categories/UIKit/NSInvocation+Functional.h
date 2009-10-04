//
//  NSInvocation+Functional.h
//  tap
//
//  Created by William Lindmeier on 5/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSInvocation (Functional)

+ (NSInvocation *)invocationUsingSelector:(SEL)aSelector onTarget:(id)target argumentList:(va_list)argumentList;

@end
