//
//  NSObject+Helpers.m
//  BN
//
//  Created by William Lindmeier on 10/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObject+Helpers.h"


@implementation NSManagedObject(Helpers)

- (NSError *)errorFromOriginalError:(NSError *)originalError error:(NSError *)secondError
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    NSMutableArray *errors = [NSMutableArray arrayWithObject:secondError];

    if ([originalError code] == NSValidationMultipleErrorsError) {

        [userInfo addEntriesFromDictionary:[originalError userInfo]];
        [errors addObjectsFromArray:[userInfo objectForKey:NSDetailedErrorsKey]];
    }
    else {
        [errors addObject:originalError];
    }

    [userInfo setObject:errors forKey:NSDetailedErrorsKey];

    return [NSError errorWithDomain:NSCocoaErrorDomain
                               code:NSValidationMultipleErrorsError
                           userInfo:userInfo];
}

@end
