//
//  ModelValidation.h
//  tap
//
//  Created by William Lindmeier on 6/16/09.
//  Copyright 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelValidation.h"

#define kValidationMessageKey		@"message"
#define kValidationAllowsNilKey		@"allowsNil"
#define kValidationRangeMaximumKey	@"rangeMax"
#define kValidationRangeMinimumKey	@"rangeMin"

@class Model;

typedef enum ValidationTypes {
	ValidationTypeNone = 0,
	ValidatesExistence,
	ValidatesAssociated,
	ValidatesNonEmptyString,
	ValidatesNonZeroNumber,
	ValidatesNumberInRange
} ValidationType;

@interface ModelValidation : NSObject {
	ValidationType validationType;
	NSString *propertyName;
	NSString *errorMessage;
	NSDictionary *options;
}

@property (nonatomic, readonly) NSString *errorMessage;

- (id)initWithValidationType:(ValidationType)type propertyName:(NSString *)propName options:(NSDictionary *)optionsOrNil;
- (NSString *)validateAgainstRecord:(Model *)record;

@end

// Helper functions

NSDictionary* NumberValidationDictionaryWithRange(NSRange numRange);
