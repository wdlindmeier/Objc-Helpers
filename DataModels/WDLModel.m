//
//  WDLModel.m
//  tap
//
//  Created by William Lindmeier on 5/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WDLModel.h"
#import "WDLPotentialValueObject.h"
#import "JSON.h"

@implementation WDLModel 

@synthesize errorMessages;

@dynamic createdAt;
@dynamic updatedAt;
@dynamic isPersisted;

#pragma mark Accessors 

- (WDLPotentialValueObject *)propertyWithName:(NSString *)propName{
	WDLPotentialValueObject * varietalProp = [[[WDLPotentialValueObject alloc] initWithParentObject:self
											propertyName:propName] autorelease];
	return varietalProp;
}

#pragma mark Save / Validation 

- (BOOL)save
{	
	// This validates the object on save. If isValid is called before save, the validation is redundant
	BOOL valid = [self isValid];
	if(valid){		
		[self persist];
		// Set the time stamps
		NSDate *now = [NSDate date];
		if(!self.createdAt) self.createdAt = now;
		self.updatedAt = now;
	}
	return valid;	
}

- (BOOL)isValid
{		
	BOOL valid = YES;
	
	[errorMessages release];
	NSMutableArray *validationErrors = [NSMutableArray array];
	
	for(WDLModelValidation *validation in [self validations]){
		NSString *errorMessage = [validation validateAgainstRecord:self];
		if(errorMessage){
			[validationErrors addObject:errorMessage];
			valid = NO;
		}
	}
	errorMessages = valid ? nil : [validationErrors componentsJoinedByString:@"\n"];
	[errorMessages retain];

	return valid;
}

- (NSArray *)validations
{
	return [NSArray array];
}

#pragma mark Core Data 

// NOTE: This is the ONLY place isPersisted should be set, otherwise we might get infinite loops
- (void)persist
{	
	if(![self.isPersisted boolValue]){
		self.isPersisted = [NSNumber numberWithBool:YES];
		[self persistAssociatedRecords];
	}
}

// Persist any associated objects, so they are in the context when the app saves
- (void)persistAssociatedRecords
{
	NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
											  inManagedObjectContext:[ManagedContextController sharedContext]];
	NSDictionary *relationshipsByName = [entity relationshipsByName];
	for(NSString *relationshipName in relationshipsByName){
		NSRelationshipDescription *relationship = [relationshipsByName objectForKey:relationshipName];
		if(![relationship isToMany]){
			WDLModel *associatedObject = [self performSelector:NSSelectorFromString(relationshipName)];
			[associatedObject persist];
		}
	}
}

#pragma mark JSON
// Load an object with an ObjectID:
/*
 NSManagedObjectID *moID = [[ManagedContextController sharedInstance].persistentStoreCoordinator managedObjectIDForURIRepresentation:[NSURL URLWithString:value]];
 NSLog(@"objectWithID: %@", [[ManagedContextController sharedContext] objectWithID:moID]);
 */

- (NSString *)JSONRepresentation {
	SBJSON *jsonWriter = [[SBJSON alloc] init];
	NSMutableArray *jsonComponents = [NSMutableArray array];
	NSDictionary *relationshipValues = [self dictionaryWithValuesForKeys: [[[self entity] relationshipsByName] allKeys]];
	NSDictionary *attributeValues = [self dictionaryWithValuesForKeys: [[[self entity] attributesByName] allKeys]];
	NSMutableDictionary *allValues = [NSMutableDictionary dictionaryWithCapacity:[relationshipValues count] + [attributeValues count]];
	// Merge the dictionaries
	for(NSString *key in relationshipValues){
		[allValues setObject:[relationshipValues objectForKey:key] forKey:key];
	}
	for(NSString *key in attributeValues){
		[allValues setObject:[attributeValues objectForKey:key] forKey:key];
	}
	NSString *relativeID = [[[self  objectID] URIRepresentation] relativePath];
	// Set my objectID
	[allValues setObject:relativeID forKey:@"id"];
	
	// Remove persistence 
	[allValues removeObjectForKey:@"isPersisted"];
	
	for(NSString *key in allValues){
		NSObject *relationshipValue = [allValues valueForKey:key];
		NSString *keyName = nil;
		NSString *value = nil;
		if([relationshipValue isKindOfClass:[NSSet class]]){
			keyName = [NSString stringWithFormat:@"%@Ids", key];
			if([(NSSet *)relationshipValue count] > 0){
				NSArray *objectIDs = [[(NSSet *)relationshipValue allObjects] mapUsingSelector:@selector(objectID)];
				NSArray *objectURIs = [objectIDs mapUsingSelector:@selector(URIRepresentation)];
				NSArray *relativeIds = [objectURIs mapUsingSelector:@selector(relativePath)];
				NSString *ids = [relativeIds componentsJoinedByString:@"\",\""];
				value = [NSString stringWithFormat:@"[\"%@\"]", ids];
			}else{
				value = @"[]";
			}
		}else if([relationshipValue isKindOfClass:[WDLModel class]]){
			keyName = [NSString stringWithFormat:@"%@Id", key];
			value = [NSString stringWithFormat:@"\"%@\"", [[[(WDLModel *)relationshipValue objectID] URIRepresentation] relativePath]];
		}else if([relationshipValue isKindOfClass:[NSData class]]){			
			if([key isEqual:@"imageData"]){
				// this is a photo
				keyName = @"imagePath";
				value = [NSString stringWithFormat:@"\"%@%@.png\"", [self binaryPath], relativeID];
			}else{
				keyName = key;
				value = [NSString stringWithFormat:@"\"%@\"", relationshipValue];
			}
		}else{
			keyName = key;
			if(!relationshipValue || [relationshipValue isEqual:[NSNull null]]){
				value = @"null";
			}else{
				NSError *jsonError = nil;
				value = [jsonWriter stringWithObject:relationshipValue allowScalar:YES error:&jsonError];
				if(jsonError){
					value = [NSString stringWithFormat:@"\"%@\"", relationshipValue];
				}
			}
		}
		[jsonComponents addObject:[NSString stringWithFormat:@"\"%@\" : %@", keyName, value]];
	}
	return [NSString stringWithFormat:@"{\n%@\n}", [jsonComponents componentsJoinedByString:@",\n"]];
}

#pragma mark Export 

- (NSString *)binaryPath
{
	return @"Data";
}

- (void)exportBinaryDataToPath:(NSString *)aPath
{
	return;
}

#pragma mark Memory

- (void)dealloc
{
	[super dealloc];
}

#pragma mark Class methods

// This is an un-targeted way of getting all results for a class. This may be too broad.
+ (NSArray *)findAll
{

	NSString *className = NSStringFromClass([self class]);
	NSFetchRequest *request = [[NSFetchRequest alloc] init];	
	NSEntityDescription *entity = [NSEntityDescription entityForName:className
											  inManagedObjectContext:[ManagedContextController sharedContext]];	
	[request setEntity:entity];
	
	// Only show persisted objects
	NSPredicate * fetchPredicate  = [NSPredicate predicateWithFormat:@"isPersisted == YES"];
	[request setPredicate:fetchPredicate];	

	NSError *error;
	NSArray *fetchedObjects = [[ManagedContextController sharedContext] executeFetchRequest:request error:&error];
	if (fetchedObjects == nil) {		
		// Handle error		
	}
	
	[request release];
	
	return fetchedObjects;
}

+ (NSArray *)findByAttribute:(NSString *)attribute value:(id)value
{
	NSString *className = NSStringFromClass([self class]);
	NSFetchRequest *request = [[NSFetchRequest alloc] init];	
	NSEntityDescription *entity = [NSEntityDescription entityForName:className
											  inManagedObjectContext:[ManagedContextController sharedContext]];	
	[request setEntity:entity];
	
	NSString *predicateString = [NSString stringWithFormat:@"isPersisted == YES AND %@ == %%@", attribute];
	NSPredicate * fetchPredicate  = [NSPredicate predicateWithFormat:predicateString, value];
	[request setPredicate:fetchPredicate];	
	
	NSError *error = nil;
	NSArray *fetchedObjects = [[ManagedContextController sharedContext] executeFetchRequest:request error:&error];
	[request release];	
	
	if (fetchedObjects == nil) {				
		NSLog(@"Error fetching models by attribute: %@", error);
	}		
	
	return fetchedObjects;	
}

+ (WDLModel *)newRecord
{
	NSManagedObjectContext *sharedContext = [ManagedContextController sharedContext];
	NSManagedObjectModel *managedObjectModel = [[sharedContext persistentStoreCoordinator] managedObjectModel];
	NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:NSStringFromClass([self class])];
	return (WDLModel *)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:sharedContext];
}

// Add a delete warning to a class if the user should get an alert before the record is removed
+ (NSString *)deleteWarning
{
	return nil;
}

@end
