//
//  NSObject+isNotBlank.h
//  NavigationProto
//
//  Created by Bill Lindmeier on 7/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSObject(isNotBlank)

- (BOOL) isNotBlank;

@end

@interface NSArray(isNotBlank)

- (BOOL)isNotBlank;

@end

@interface NSSet(isNotBlank)

- (BOOL)isNotBlank;

@end

@interface NSDictionary(isNotBlank)

- (BOOL)isNotBlank;

@end

@interface NSString(isNotBlank)

- (BOOL)isNotBlank;

@end


@interface NSNull(isNotBlank)

- (BOOL)isNotBlank;

@end

@interface NSNumber(isNotBlank)

- (BOOL)isNotBlank;

@end
