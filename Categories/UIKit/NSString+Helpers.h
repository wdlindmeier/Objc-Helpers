//
//  NSString+Helpers.h
//  tap
//
//  Created by William Lindmeier on 6/10/09.
//  Copyright 2009. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Helpers)

- (BOOL)containsString:(NSString *)matchString;
- (BOOL)isEmpty;
+ (NSString *)setterFromGetter:(NSString *)getterName;

@end
