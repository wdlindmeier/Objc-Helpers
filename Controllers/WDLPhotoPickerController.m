//
//  WDLPhotoPickerController.m
//  tweak
//
//  Created by William Lindmeier on 11/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WDLPhotoPickerController.h"

#define kButtonNewPhotoIndex	0
#define kButtonChoosePhotoIndex	1

@implementation WDLPhotoPickerController

@synthesize delegate, photoPickerFromAlbum, photoPickerFromCamera;

#pragma mark UIControl Actions

- (void)chooseFromMediaTypes:(NSArray *)mediaTypes;
{
	[mediaTypes retain];
	[permissableMediaTypes release];
	permissableMediaTypes = mediaTypes;
	
	// If they have a camera, we'll give them the option of taking a photo.
	// Otherwise, just let them pick one.
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
		UIActionSheet *anActionSheet = [[UIActionSheet alloc] initWithTitle:nil
																   delegate:self
														  cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel <alert cancel button>")
													 destructiveButtonTitle:nil 
														  otherButtonTitles:NSLocalizedString(@"Camera", @"Take Photo <photo picker option>"), NSLocalizedString(@"Choose File", @"Choose Existing Pohot <photo picker option>"), nil];
		anActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		if(self.delegate){			
			UIViewController *viewController = [self.delegate viewControllerToPresentPhotoPicker:self];
			[anActionSheet showInView:viewController.view];
			[anActionSheet release];
		}			
	}else{
		[self chooseMediaTypesFromAlbum:mediaTypes];
	}
}

#pragma mark Action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case kButtonNewPhotoIndex:
			[self captureMediaTypesFromCamera:permissableMediaTypes];
			break;
		case kButtonChoosePhotoIndex:
			[self chooseMediaTypesFromAlbum:permissableMediaTypes];
			break;
		default:
			if(self.delegate && [(NSObject *)self.delegate respondsToSelector:@selector(photoPickerDidCancel:)]){
				[self.delegate photoPickerDidCancel:self];
			}
			break;
	}
}

#pragma mark Accessors 

- (UIImagePickerController *)photoPickerFromCamera{
	if(photoPickerFromCamera == nil){
		photoPickerFromCamera = [[UIImagePickerController alloc] init];		
		photoPickerFromCamera.delegate = self;
		photoPickerFromCamera.sourceType = UIImagePickerControllerSourceTypeCamera;
		photoPickerFromCamera.allowsEditing = NO;
		photoPickerFromCamera.view.hidden = YES;
	}	
	return photoPickerFromCamera;
}

- (UIImagePickerController *)photoPickerFromAlbum{
	if(photoPickerFromAlbum == nil){
		photoPickerFromAlbum = [[UIImagePickerController alloc] init];		
		photoPickerFromAlbum.delegate = self;
		photoPickerFromAlbum.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		photoPickerFromAlbum.allowsEditing = NO;
		photoPickerFromAlbum.view.hidden = YES;
	}	
	return photoPickerFromAlbum;
}

#pragma mark Picking a photo

- (void)chooseMediaTypesFromAlbum:(NSArray *)mediaTypes
{
	self.photoPickerFromAlbum.view.hidden = NO;
	if(self.delegate){			
		UIViewController *viewController = [self.delegate viewControllerToPresentPhotoPicker:self];
		self.photoPickerFromAlbum.mediaTypes = mediaTypes;
		[viewController presentModalViewController:self.photoPickerFromAlbum animated:YES];	
	}
}

- (void)captureMediaTypesFromCamera:(NSArray *)mediaTypes
{
	self.photoPickerFromCamera.view.hidden = NO;
	if(self.delegate){			
		UIViewController *viewController = [self.delegate viewControllerToPresentPhotoPicker:self];
		self.photoPickerFromCamera.mediaTypes = mediaTypes;
		[viewController presentModalViewController:self.photoPickerFromCamera animated:YES];
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSObject *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	if([mediaType isEqual:(NSString *)kUTTypeImage]){	
		
		// Picked an image. Return the image.
		UIImage *image;
		if(picker.allowsEditing){
			image = [info objectForKey:UIImagePickerControllerEditedImage];
		}else{
			image = [info objectForKey:UIImagePickerControllerOriginalImage];
		}
		[image retain];
		// Nilling out the images in the dict to conserve memory
		[info setValue:nil forKey:UIImagePickerControllerOriginalImage];
		[info setValue:nil forKey:UIImagePickerControllerEditedImage];
		// Re-orients the image data 
		// image = [image resizedImage:image.size interpolationQuality:kCGInterpolationDefault];
		if(self.delegate && [(NSObject *)self.delegate respondsToSelector:@selector(photoPicker:didPickImage:)]){	
			UIViewController *viewController = [self.delegate viewControllerToPresentPhotoPicker:self];
			[viewController dismissModalViewControllerAnimated:YES];
			[self.delegate photoPicker:self didPickImage:[image autorelease]];
		}
	}else if([mediaType isEqual:(NSString *)kUTTypeMovie]){
		
		// Picked a video: Return the URL
		NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
		if(self.delegate && [(NSObject *)self.delegate respondsToSelector:@selector(photoPicker:didPickVideoAtURL:)]){			
			UIViewController *viewController = [self.delegate viewControllerToPresentPhotoPicker:self];
			[viewController dismissModalViewControllerAnimated:YES];
			[self.delegate photoPicker:self didPickVideoAtURL:videoURL];
		}
	}
	
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	if(self.delegate){
		UIViewController *viewController = [self.delegate viewControllerToPresentPhotoPicker:self];
		[viewController dismissModalViewControllerAnimated:YES];
		if([(NSObject *)self.delegate respondsToSelector:@selector(photoPickerDidCancel:)]){
			[self.delegate photoPickerDidCancel:self];
		}
	}	
}

#pragma mark Memory 

- (void)dealloc
{
	self.photoPickerFromAlbum = nil;
	self.photoPickerFromCamera = nil;
	self.delegate = nil;
	[permissableMediaTypes release];
	[super dealloc];
}

@end
