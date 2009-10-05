//
//  Model.h
//  tap
//
//  Created by William Lindmeier on 5/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define kValidationErrorMultipleCode	1560
#define kValidationErrorSingleCode		404

#import "ManagedContextController.h"
#import "ModelValidation.h"

@class PotentialValueObject;

@interface Model :  NSManagedObject  
{
	NSString *errorMessages;
}

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * isPersisted;

@property (nonatomic, readonly) NSString * errorMessages;

- (PotentialValueObject *)propertyWithName:(NSString *)propName;
- (BOOL)isValid;
- (BOOL)save;
- (void)persist;
- (void)persistAssociatedRecords;
- (NSArray *)validations;
- (void)exportBinaryDataToPath:(NSString *)aPath;
- (NSString *)binaryPath;
- (NSString *)JSONRepresentation;

+ (NSString *)deleteWarning;
+ (NSArray *)findAll;
+ (NSArray *)findByAttribute:(NSString *)attribute value:(id)value;
+ (Model *)newRecord;


@end
