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
	NSArray *recordErrors = [self objectWithString:resultsString error:errorPointer];	
	NSString *errorMessage = nil;
	if(recordErrors){
		NSMutableString *joinedErrors = [NSMutableString string];
		for(NSArray *error in recordErrors){
			[joinedErrors appendString:@"\n"];
			[joinedErrors appendString:[error componentsJoinedByString:@" "]];
		}
		errorMessage = joinedErrors;		
	}
	return errorMessage;
}

@end
