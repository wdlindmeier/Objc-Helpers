//
//  WDLPhotoPickerController.h
//  tweak
//
//  Created by William Lindmeier on 11/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDLPhotoPickerController;

@protocol WDLPhotoPickerDelegate

@required
- (void)photoPicker:(WDLPhotoPickerController *)aPhotoPicker didPickImage:(UIImage *)anImage;
- (UIViewController *)viewControllerToPresentPhotoPicker:(WDLPhotoPickerController *)aPhotoPicker;

@optional

- (void)photoPickerDidCancel:(WDLPhotoPickerController *)aPhotoPicker;

@end

@interface WDLPhotoPickerController : NSObject <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
	
	UIImagePickerController *photoPickerFromCamera;
	UIImagePickerController *photoPickerFromAlbum;
	id <WDLPhotoPickerDelegate>delegate;
	
}

@property (assign) id <WDLPhotoPickerDelegate> delegate;

- (void)choosePhoto;
- (void)choosePhotoFromAlbum;
- (void)capturePhotoFromCamera;

+ (WDLPhotoPickerController *)sharedInstance;

@end
