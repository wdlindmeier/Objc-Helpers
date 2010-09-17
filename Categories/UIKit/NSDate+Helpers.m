//
//  NSDate+Helpers.m
//  tap
//
//  Created by William Lindmeier on 6/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Helpers.h"

static NSDateFormatter *sharedFormatter;

@implementation NSDate(Helpers)

- (int)year
{
	NSDateFormatter *dateFormatter = [NSDate sharedFormatter];
	[dateFormatter setDateFormat:@"yyyy"];
	return [[dateFormatter stringFromDate:self] intValue];
}
- (int)month
{
	NSDateFormatter *dateFormatter = [NSDate sharedFormatter];
	[dateFormatter setDateFormat:@"MM"];
	return [[dateFormatter stringFromDate:self] intValue];
}
- (int)day
{	
	NSDateFormatter *dateFormatter = [NSDate sharedFormatter];
	[dateFormatter setDateFormat:@"dd"];
	return [[dateFormatter stringFromDate:self] intValue];
}
- (int)hour
{
	NSDateFormatter *dateFormatter = [NSDate sharedFormatter];
	[dateFormatter setDateFormat:@"HH"];
	return [[dateFormatter stringFromDate:self] intValue];
}
- (int)minute
{
	NSDateFormatter *dateFormatter = [NSDate sharedFormatter];
	[dateFormatter setDateFormat:@"mm"];
	return [[dateFormatter stringFromDate:self] intValue];
}
- (int)second
{
	NSDateFormatter *dateFormatter = [NSDate sharedFormatter];
	[dateFormatter setDateFormat:@"ss"];
	return [[dateFormatter stringFromDate:self] intValue];
}

- (NSDate *)dateFromDaysOffset:(NSInteger)daysOffset
{
	// start by retrieving day, weekday, month and year components for yourDate
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:daysOffset];
    NSDate *offsetDate = [gregorian dateByAddingComponents:offsetComponents toDate:self options:0];
    [offsetComponents release];
    [gregorian release];	

	return offsetDate;
}

+ (NSDateFormatter *)sharedFormatter
{
	if(sharedFormatter == nil){
		sharedFormatter = [[NSDateFormatter alloc] init];
	}
	return sharedFormatter;
}

+ (NSDate *)dateFromJSONFormattedString:(NSString *)JSONstring
{
	// Strip any +dd:dd or -dd:dd or Z from the end of the string
	int stringLength = [JSONstring length];
	NSString *stringSansTZ = [JSONstring stringByReplacingOccurrencesOfString:@"(Z|(\\+|\\-)\\d\\d:\\d\\d)$" 
																   withString:@"" 
																	  options:NSRegularExpressionSearch 
																		range:NSMakeRange(0, stringLength)];
	NSDate *parsed = nil;
	NSDateFormatter *dateFormatter = [NSDate sharedFormatter];
	//2011-09-17T03:36:27
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
	@try {
		parsed = [dateFormatter dateFromString:stringSansTZ];
	}
	@catch (NSException * e) {
		NSLog(@"NSDate Error: Could not parse date from %@", stringSansTZ);
	}	
	return parsed;
}
	
@end
