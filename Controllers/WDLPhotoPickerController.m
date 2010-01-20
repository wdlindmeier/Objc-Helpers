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

static WDLPhotoPickerController *sharedController = nil;

@implementation WDLPhotoPickerController

@synthesize delegate;

#pragma mark UIControl Actions

- (void)choosePhoto
{
	// If they have a camera, we'll give them the option of taking a photo.
	// Otherwise, just let them pick one.
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
		UIActionSheet *anActionSheet = [[UIActionSheet alloc] initWithTitle:nil
																   delegate:self
														  cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel <alert cancel button>")
													 destructiveButtonTitle:nil 
														  otherButtonTitles:NSLocalizedString(@"Take Photo", @"Take Photo <photo picker option>"), NSLocalizedString(@"Choose Existing Photo", @"Choose Existing Pohot <photo picker option>"), nil];
		anActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		if(self.delegate){			
			UIViewController *viewController = [self.delegate viewControllerToPresentPhotoPicker:self];
			[anActionSheet showInView:viewController.view];
			[anActionSheet release];
		}			
	}else{
		[self choosePhotoFromAlbum];
	}
}

#pragma mark Action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case kButtonNewPhotoIndex:
			[self capturePhotoFromCamera];
			break;
		case kButtonChoosePhotoIndex:
			[self choosePhotoFromAlbum];
			break;
		default:
			if(self.delegate && [(NSObject *)self.delegate respondsToSelector:@selector(photoPickerDidCancel:)]){
				[self.delegate photoPickerDidCancel:self];
			}
			break;
	}
}

#pragma mark Picking a photo

- (void)choosePhotoFromAlbum
{
	if(photoPickerFromAlbum == nil){
		photoPickerFromAlbum = [[UIImagePickerController alloc] init];		
		photoPickerFromAlbum.delegate = self;
		photoPickerFromAlbum.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		photoPickerFromAlbum.allowsEditing = NO;
		photoPickerFromAlbum.view.hidden = YES;
		[[UIApplication sharedApplication].keyWindow addSubview:photoPickerFromAlbum.view];
	}
	photoPickerFromAlbum.view.hidden = NO;
	if(self.delegate){			
		UIViewController *viewController = [self.delegate viewControllerToPresentPhotoPicker:self];
		[viewController presentModalViewController:photoPickerFromAlbum animated:YES];	
	}
}

- (void)capturePhotoFromCamera
{
	if(photoPickerFromCamera == nil){
		photoPickerFromCamera = [[UIImagePickerController alloc] init];		
		photoPickerFromCamera.delegate = self;
		photoPickerFromCamera.sourceType = UIImagePickerControllerSourceTypeCamera;
		photoPickerFromCamera.allowsEditing = NO;
		photoPickerFromCamera.view.hidden = YES;
		[[UIApplication sharedApplication].keyWindow addSubview:photoPickerFromCamera.view];
	}
	photoPickerFromCamera.view.hidden = NO;
	if(self.delegate){			
		UIViewController *viewController = [self.delegate viewControllerToPresentPhotoPicker:self];
		[viewController presentModalViewController:photoPickerFromCamera animated:YES];
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	if(self.delegate){			
		UIViewController *viewController = [self.delegate viewControllerToPresentPhotoPicker:self];
		[viewController dismissModalViewControllerAnimated:YES];
		[delegate photoPicker:self didPickImage:image];
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

#pragma mark singleton controller methods

+ (WDLPhotoPickerController *)sharedInstance {
	if (sharedController == nil) {
		sharedController = [[self alloc] init];
	}
    return sharedController;
}

#pragma mark Memory 

- (void)dealloc
{
	self.delegate = nil;
	[super dealloc];
}

@end