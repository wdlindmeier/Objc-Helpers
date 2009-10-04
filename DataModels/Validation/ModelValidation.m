//
//  ModelValidation.m
//  tap
//
//  Created by William Lindmeier on 6/16/09.
//  Copyright 2009. All rights reserved.
//

#import "ModelValidation.h"
#import "PotentialValueObject.h"
#import "Model.h"

@implementation ModelValidation

@dynamic errorMessage;

- (id)initWithValidationType:(ValidationType)type propertyName:(NSString *)propName options:(NSDictionary *)optionsOrNil
{
	if(self = [super init]){
		validationType = type;
		propertyName = [propName retain];
		options = [optionsOrNil retain];
		if(options){
			// Might be nil
			errorMessage = [[options objectForKey:kValidationMessageKey] retain]; 
		}
	}
	return self;
}

#pragma mark Accessors
// If the error message wasnt passed in, we'll generate one based on the validation type
- (NSString *)errorMessage
{
	if(errorMessage == nil){		
		NSString *humanizedPropertyName = NSLocalizedString([propertyName capitalizedString], [propertyName capitalizedString]);
		switch (validationType) {
			case ValidatesExistence:
				errorMessage = [NSString stringWithFormat:@"%@ %@.", humanizedPropertyName,
								NSLocalizedString(@"can't be blank", @"can't be blank <validation>")];
				break;
			case ValidatesAssociated:
				errorMessage = [NSString stringWithFormat:@"%@ %@.", humanizedPropertyName,
								NSLocalizedString(@"is invalid", @"is invalid <validation>")];
				break;
			case ValidatesNonEmptyString:
				errorMessage = [NSString stringWithFormat:@"%@ %@.", humanizedPropertyName,
								NSLocalizedString(@"can't be blank", @"can't be blank <validation>")];
				break;				
			case ValidatesNonZeroNumber:
				errorMessage = [NSString stringWithFormat:@"%@ %@.", humanizedPropertyName,
								NSLocalizedString(@"must not be 0", @"must not be 0 <validation>")];
				break;				
			case ValidatesNumberInRange:
				errorMessage = [NSString stringWithFormat:@"%@ %@.", humanizedPropertyName,
								NSLocalizedString(@"does not fall within the accepted range", @"does not fall within the accepted range <validation>")];
				break;
			default:
				errorMessage = [NSString stringWithFormat:@"%@ %@.", humanizedPropertyName, NSLocalizedString(@"is not valid", @"is not valid <validation>")];
				break;
		}
		[errorMessage retain];
	}
	return errorMessage;
}

// Will return an error message (NSString) if the record is invalid, or nil if it's valid
- (NSString *)validateAgainstRecord:(Model *)record
{
	PotentialValueObject *propObject = [[PotentialValueObject alloc] initWithParentObject:record propertyName:propertyName];
	BOOL invalid = NO;
	id currentValue = [propObject currentValue];

	// ValidatesExistence
	if(currentValue == nil){ 

		BOOL allowsNil = [options valueForKey:kValidationAllowsNilKey] && [[options valueForKey:kValidationAllowsNilKey] boolValue];
		invalid = allowsNil ? NO : YES;

	}else if(validationType == ValidatesAssociated){
		
		if(![(Model *)currentValue isValid]) invalid = YES;

	}else if(validationType == ValidatesNonEmptyString){
		
		if([(NSString *)currentValue isEmpty]) invalid = YES;

	}else if(validationType == ValidatesNonZeroNumber){
		
		if([(NSNumber *)currentValue intValue] == 0) invalid = YES;

	}else if(validationType == ValidatesNumberInRange){
		
		NSNumber *minValue = [options valueForKey:kValidationRangeMinimumKey];
		if(minValue && [minValue intValue] > [currentValue intValue]) invalid = YES;

		NSNumber *maxValue = [options valueForKey:kValidationRangeMaximumKey];
		if(maxValue && [maxValue intValue] < [currentValue intValue]) invalid = YES;
		
	}else{		
		// default
	}
	return invalid ? self.errorMessage : nil;
}

- (void)dealloc
{
	[propertyName release];
	[errorMessage release];
	[options release];
	[super dealloc];
}

@end

// Helper functions

NSDictionary* NumberValidationDictionaryWithRange(NSRange numRange)
{
	
	return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:numRange.location], kValidationRangeMinimumKey,
			[NSNumber numberWithInt:(numRange.location + numRange.length)], kValidationRangeMaximumKey, nil];

}