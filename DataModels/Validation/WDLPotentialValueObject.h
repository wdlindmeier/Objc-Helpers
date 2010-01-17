//
//  PropertyObject.h
//  tap
//
//  Created by William Lindmeier on 6/15/09.
//  Copyright 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDLPotentialValueObject : NSObject {
	NSObject *parentObject;	
	NSString *propertyName;
}

@property (nonatomic, retain) NSObject *parentObject;
@property (nonatomic, retain) NSString *propertyName;

- (id)initWithParentObject:(NSObject *)obj propertyName:(NSString *)propName;
- (id)currentValue;
- (id)newPropertyObject;

@end
