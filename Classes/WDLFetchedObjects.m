//
//  WDLFetchedObjects.m
//  BN
//
//  Created by William Lindmeier on 10/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WDLFetchedObjects.h"

@implementation WDLFetchedObjects

- (void)setObjectsFromFetchedResultsController:(NSFetchedResultsController *)fetchController
{
	[collection release];
	NSArray *sections = fetchController.sections;
	collection = [[NSMutableArray alloc] initWithCapacity:[sections count]];
	for(id <NSFetchedResultsSectionInfo> section in sections){
		[collection addObject:[section objects]];
	}
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
	return [self objectAtSection:indexPath.section row:indexPath.row];
}

- (id)objectAtSection:(NSUInteger)section row:(NSUInteger)row
{
	if([self countAtSection:section] > row){
		return [(NSArray *)[collection objectAtIndex:section] objectAtIndex:row];
	}
	return nil;
}

- (int)countAtSection:(NSUInteger)section
{
	if([self numberOfSections] > section){
		NSArray *sectionCollection = [collection objectAtIndex:section];
		return [sectionCollection count];
	}
	return 0;
}

- (int)numberOfSections
{
	return [collection count];
}

- (void)dealloc
{
	[collection release];
	[super dealloc];
}

@end
