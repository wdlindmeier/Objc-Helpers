//
//  ManagedContextController+Serialize.m
//  tap
//
//  Created by William Lindmeier on 9/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ManagedContextController+Serialize.h"
#import "WDLModel.h"

@implementation ManagedContextController(Serialize)

// NOTE: This is also 

- (NSString *)serializedGraphDataForExportPath:(NSString *)exportPath{

	NSArray *entityNames = [[[ManagedContextController sharedInstance].managedObjectModel entitiesByName] allKeys];
	NSMutableDictionary *exportData = [[NSMutableDictionary alloc] init];

	for(NSString *name in entityNames){
		// NOTE: This should only serialized requested classes, not superclasses
		
		if(![name isEqual:@"WDLModel"] && ![name isEqual:@"NamedModel"]){
			id modelClass = NSClassFromString(name);
			NSArray *allRecords = [modelClass findAll];
			NSMutableArray *jsonData = [NSMutableArray array];			
			for(WDLModel *record in allRecords){
				[jsonData addObject:[record JSONRepresentation]];
				[record exportBinaryDataToPath:[exportPath stringByAppendingPathComponent:[record binaryPath]]];
			}
			NSString *arrayString = [NSString stringWithFormat:@"[%@]", [jsonData componentsJoinedByString:@",\n"]];
			[exportData setObject:arrayString forKey:name];
		}
	}
	
	NSMutableString *dataString = [NSMutableString stringWithString:@"{ \"WineNotesData\" : {"];
	for(NSString *key in exportData){
		[dataString appendString:[NSString stringWithFormat:@"\"%@\" : %@,\n", key, [exportData objectForKey:key]]];
	}

	// Remove the last comma
	[dataString deleteCharactersInRange:NSMakeRange([dataString length] - 2, 1)];
	[dataString appendString:@"\n}}"];
	
	return dataString;
}

@end
