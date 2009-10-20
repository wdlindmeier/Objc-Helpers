//
//  NSDate+Helpers.h
//  tap
//
//  Created by William Lindmeier on 6/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate(Helpers)

- (int)year;
- (int)month;
- (int)day;
- (int)hour;
- (int)minute;
- (int)second;
- (NSDate *)dateFromDaysOffset:(NSInteger)daysOffset;
+ (NSDateFormatter *)sharedFormatter;

@end
