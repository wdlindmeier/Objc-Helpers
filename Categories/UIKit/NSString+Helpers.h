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
- (NSArray *)camelCaseComponents;
- (NSString *)titleizedStringFromCamelCase;
- (NSString *)underscoredStringFromCamelCase;
- (NSString*)stringWithPercentEscape;
- (NSString*)stringByUnescapingPercentEscape;
+ (NSString *)setterFromGetter:(NSString *)getterName;
+ (NSDictionary *)dictionaryFromQueryParams:(NSString *)paramsString lowercaseKeys:(BOOL)shouldLowercase;

@end
