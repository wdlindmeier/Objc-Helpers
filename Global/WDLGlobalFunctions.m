//
//  WDLGlobalFunctions.m
//  Chaucer
//
//  Created by William Lindmeier on 8/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WDLGlobalFunctions.h"

NSString * pathForDocumentFileNamed(NSString *fileName)
{
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:fileName];		
}

NSURL * urlForDocumentFileNamed(NSString *fileName)
{
	return [NSURL fileURLWithPath:pathForDocumentFileNamed(fileName)];
}

NSString * pathForBundleFileNamed(NSString *fileName)
{
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *path = [bundle pathForResource:[fileName stringByDeletingPathExtension] 
									  ofType:[fileName pathExtension]];
	return path;
}

NSURL * urlForBundleFileNamed(NSString *fileName)
{
	NSString *path = pathForBundleFileNamed(fileName);
	return path ? [NSURL fileURLWithPath:path] : nil;
}