//
//  PropertyObject.m
//  tap
//
//  Created by William Lindmeier on 6/15/09.
//  Copyright 2009. All rights reserved.
//

#import "PotentialValueObject.h"
#import "ManagedContextController.h"
#import <objc/runtime.h>


@implementation PotentialValueObject

@synthesize parentObject, propertyName;

- (id)initWithParentObject:(NSObject *)obj propertyName:(NSString *)propName
{
	if(self = [super init]){
		self.parentObject = obj;
		self.propertyName = propName;
	}
	return self;
}

// Returns a "newRecord" of the property type
// and assgns it to the parentObject
- (id)newPropertyObject
{	
	id propertyRecord = nil;
	objc_property_t theProperty = class_getProperty([self.parentObject class], [self.propertyName UTF8String]);
	if(theProperty){
		NSString *propertyAttrs = [NSString stringWithCString:property_getAttributes(theProperty)];
		// T@"Producer",&,Vproducer
		NSArray *propAttrComponents = [propertyAttrs componentsSeparatedByString:@"\""];
		NSString *propertyClassName = [propAttrComponents objectAtIndex:1];
		// @"Producer"
		id recordClass = NSClassFromString(propertyClassName);
		// If this is a Model, we'll send a "newRecord", otherwise alloc init.
		if([recordClass respondsToSelector:@selector(newRecord)]){
			propertyRecord = [recordClass performSelector:@selector(newRecord)];			
		}else{
			propertyRecord = [[[recordClass alloc] init] autorelease];
		}
	}
	return propertyRecord;
}

- (id)currentValue{
	return [self.parentObject performSelector:NSSelectorFromString(self.propertyName)];
}

- (void)dealloc
{
	self.propertyName = nil;
	self.parentObject = nil;
	[super dealloc];
}

@end
