//
//  WDLGlobalFunctions.h
//  Chaucer
//
//  Created by William Lindmeier on 8/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Release(x)		[x release];x = nil

NSString * pathForDocumentFileNamed(NSString *fileName);
NSURL * urlForDocumentFileNamed(NSString *fileName);
NSString * pathForBundleFileNamed(NSString *fileName);
NSURL * urlForBundleFileNamed(NSString *fileName);
