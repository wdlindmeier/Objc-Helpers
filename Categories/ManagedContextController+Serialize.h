//
//  ManagedContextController+Serialize.h
//  tap
//
//  Created by William Lindmeier on 9/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagedContextController.h"

@interface ManagedContextController(Serialize)

- (NSString *)serializedGraphDataForExportPath:(NSString *)exportPath;

@end
