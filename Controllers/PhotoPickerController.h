//
//  PhotoPickerController.h
//  tweak
//
//  Created by William Lindmeier on 11/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PhotoPickerDelegate

@required
- (void)photoPickerDidPickImage:(UIImage *)anImage;
- (UIViewController *)viewControllerToPresentPhotoPicker:(PhotoPickerController *)aPhotoPicker;

@optional
- (void)photoPickerDidCancel;

@end

@interface PhotoPickerController : NSObject <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
	
	UIViewController *viewController;
	UIImagePickerController *photoPickerFromCamera;
	UIImagePickerController *photoPickerFromAlbum;
	id <PhotoPickerDelegate>delegate;
	
}

@property (assign) id <PhotoPickerDelegate> delegate;

- (void)choosePhoto;
- (void)choosePhotoFromAlbum;
- (void)capturePhotoFromCamera;

+ (PhotoPickerController *)sharedInstance;

@end
