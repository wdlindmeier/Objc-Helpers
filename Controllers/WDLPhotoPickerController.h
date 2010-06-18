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

- (UIViewController *)viewControllerToPresentPhotoPicker:(WDLPhotoPickerController *)aPhotoPicker;

@optional

- (void)photoPicker:(WDLPhotoPickerController *)aPhotoPicker didPickImage:(UIImage *)anImage;
- (void)photoPickerDidCancel:(WDLPhotoPickerController *)aPhotoPicker;
- (void)photoPicker:(WDLPhotoPickerController *)aPhotoPicker didPickVideoAtURL:(NSURL *)videoURL;

@end

@interface WDLPhotoPickerController : NSObject <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
	
	UIImagePickerController *photoPickerFromCamera;
	UIImagePickerController *photoPickerFromAlbum;
	id <WDLPhotoPickerDelegate>delegate;
	NSArray *permissableMediaTypes;
	
}

@property (assign) id <WDLPhotoPickerDelegate> delegate;
@property (nonatomic, retain) UIImagePickerController *photoPickerFromCamera;
@property (nonatomic, retain) UIImagePickerController *photoPickerFromAlbum;

- (void)chooseFromMediaTypes:(NSArray *)mediaTypes;
- (void)chooseMediaTypesFromAlbum:(NSArray *)mediaTypes;
- (void)captureMediaTypesFromCamera:(NSArray *)mediaTypes;

@end
