//
//  NSObject+Helpers.h
//  BN
//
//  Created by William Lindmeier on 10/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSManagedObject(Helpers)

- (NSError *)errorFromOriginalError:(NSError *)originalError error:(NSError *)secondError;

@end
