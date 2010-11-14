//
//  NSObject+Swizzle.m
//  NavigationProto
//
//  Created by Bill Lindmeier on 9/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject(Swizzle)

+ (void)swizzleClassMethod:(SEL)originalSelector withReplacement:(SEL)replacementSelector
{	
	Method originalMethod = class_getClassMethod([self class], originalSelector);
	Method replacementMethod = class_getClassMethod([self class], replacementSelector);
	method_exchangeImplementations(replacementMethod, originalMethod);	
}

+ (void)swizzleInstanceMethod:(SEL)originalSelector withReplacement:(SEL)replacementSelector
{
	Method originalMethod = class_getInstanceMethod([self class], originalSelector);
	Method replacementMethod = class_getInstanceMethod([self class], replacementSelector);
	method_exchangeImplementations(replacementMethod, originalMethod);	
}

@end
