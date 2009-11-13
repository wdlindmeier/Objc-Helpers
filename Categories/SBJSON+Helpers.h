//
//  SBJSON+Helpers.h
//  tweak
//
//  Created by William Lindmeier on 11/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SBJSON.h"

@interface SBJSON(Helpers)

- (NSString *)errorStringWithRailsErrorString:(NSString *)resultsString error:(NSError **)errorPointer;

@end
