//
//  WDLFetchedObjects.h
//  BN
//
//  Created by William Lindmeier on 10/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WDLFetchedObjects : NSObject 
{
	NSMutableArray *collection;
}

- (void)setObjectsFromFetchedResultsController:(NSFetchedResultsController *)controller;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (id)objectAtSection:(NSUInteger)section row:(NSUInteger)row;
- (int)countAtSection:(NSUInteger)section;
- (int)numberOfSections;

@end
