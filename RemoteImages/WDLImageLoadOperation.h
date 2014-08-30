//
//  WDLImageLoadOperation.h
//  NavigationProto
//
//  Created by Bill Lindmeier on 6/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WDLImageLoadOperation : NSOperation {

	NSURL *imageURL;
	BOOL immediatelySaveToDisk;

}

@property (nonatomic, retain) NSURL *imageURL;
@property (nonatomic, assign) BOOL immediatelySaveToDisk;
@property BOOL isExecuting;
@property BOOL isFinished;

@end
