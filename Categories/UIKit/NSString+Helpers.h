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
- (NSArray *)camelCaseComponents;
- (NSString *)camelCaseStringFromUnderscored;
- (NSString *)titleizedStringFromCamelCase;
- (NSString *)underscoredStringFromCamelCase;
- (NSString*)stringWithPercentEscape;
- (NSString*)stringByUnescapingPercentEscape;
- (NSString *)normalizedString;
- (NSString *)stringByIncrementingCharacters;
- (NSString *)stringByStrippingString;
- (NSString *)stringByPluralizingString;
- (NSString *)stringByCapitalizingFirstLetter;

+ (NSString *)setterFromGetter:(NSString *)getterName;
+ (NSDictionary *)dictionaryFromQueryParams:(NSString *)paramsString lowercaseKeys:(BOOL)shouldLowercase;
+ (NSString *)udid;
+ (NSString *)currencyStringForNumber:(NSNumber *)amount truncateZeros:(BOOL)truncateZeros;

@end


static inline NSInteger caseInsensitiveCompareSort(id obj1, id obj2, void *keyPath)
{	
    NSString *s1 = [obj1 valueForKeyPath:keyPath];
    NSString *s2 = [obj2 valueForKeyPath:keyPath];
	return [s1 caseInsensitiveCompare:s2];
}
