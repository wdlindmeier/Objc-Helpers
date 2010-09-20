//
//  NSObject+Swizzle.h
//  NavigationProto
//
//  Created by Bill Lindmeier on 9/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject(Swizzle)

+ (void)swizzleInstanceMethod:(SEL)originalSelector withReplacement:(SEL)replacementSelector;
+ (void)swizzleClassMethod:(SEL)originalSelector withReplacement:(SEL)replacementSelector;

@end
