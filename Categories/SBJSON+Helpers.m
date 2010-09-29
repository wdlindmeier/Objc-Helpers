//
//  SBJSON+Helpers.m
//  tweak
//
//  Created by William Lindmeier on 11/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SBJSON+Helpers.h"

@implementation SBJSON(Helpers)

- (NSString *)errorStringWithRailsErrorString:(NSString *)resultsString error:(NSError **)errorPointer
{
	NSDictionary *errorsAndKeys = [self errorDictionaryWithRailsErrorString:resultsString error:errorPointer];
	if(errorsAndKeys){
		NSMutableArray *joinedErrors = [NSMutableArray array];
		for(NSString *attrName in errorsAndKeys){
			NSArray *errors = [errorsAndKeys valueForKey:attrName];
			for(NSString *error in errors){
				[joinedErrors addObject:[NSString stringWithFormat:@"%@ %@", attrName, error]]; 
			}
		}
		return [joinedErrors componentsJoinedByString:@"\n"];
	}
	return nil;
}

- (NSDictionary *)errorDictionaryWithRailsErrorString:(NSString *)resultsString error:(NSError **)errorPointer
{
	NSArray *recordErrors = [self objectWithString:resultsString error:errorPointer];	
	if(recordErrors){
		NSMutableDictionary *collectedErrors = [NSMutableDictionary dictionary];
		for(NSArray *error in recordErrors){
			NSString *errorAttr = [error objectAtIndex:0];
			NSMutableArray *errorCollection = [collectedErrors valueForKey:errorAttr];
			if(!errorCollection){
				errorCollection = [NSMutableArray array];
				[collectedErrors setValue:errorCollection forKey:errorAttr];
			}
			[errorCollection addObject:[error objectAtIndex:1]];
		}		
		return collectedErrors;
	}	
	return nil;	
}

@end
