//
//  CHSpeakerAddViewController.m
//  CHParse
//
//  Created by Julien on 01/02/2014.
//  Copyright (c) 2014 WebD. All rights reserved.
//

#import "CHSpeakerAddViewController.h"

@interface CHSpeakerAddViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation CHSpeakerAddViewController

- (IBAction)imageButtonAction:(id)sender
{
	// Quand l'utilisateur appuie sur le bouton "Choisir une photo"
	// on lance simplement un UIImagePickerController
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
	picker.delegate = self;
	[self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
		didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo
{
	// Quand il a séléctionné une image, on la stocke
	[self handleImagePick:image];
    
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleImagePick:(UIImage *)image
{
	// Il s'agit simplement de garder un pointeur vers l'image
	// et de l'afficher ...
	currentAvatar_       = image;
	self.imageView.image = image;
	[self updateDoneButtonStatus];
}

- (IBAction)doneButtonAction:(id)sender
{
	[self uploadImage:currentAvatar_];
}

- (void)uploadImage:(UIImage *)image
{
	// On récupère un NSData (une représentation JPG) de l'UIImage
	NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    
	// Et on en crée un PFFile
	PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
	// Il ne reste plus qu'à uploader le fichier
	[imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // Si tout s'est bien passé, on continue l'opération et on
        // va créer l'objet speaker
        if (succeeded) {
            [self createSpeakerWithFile:imageFile];
        } else {
            // Sinon, on traite l'erreur
            [self showError:error];
        }
    } progressBlock:^(int percentDone) {
        // En attendant, on affiche la progression de l'upload
        [self setLoadingProgress:percentDone / 100.0];
    }];
}

- (void)createSpeakerWithFile:(PFFile *)file
{
	[self setLoadingProgress:-1];
    
	// On crée un objet de classe Speaker
	PFObject *obj = [PFObject objectWithClassName:@"Speaker"];
	// On sette le nom
	obj[@"name"] = self.nameTextField.text;
	// Et pour l'avatar, on sette le fichier fraichement uploadé
	obj[@"avatar"] = file;
    
	[obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // En cas d'erreur ...
        if (error) {
            [self showError:error];
        } else {
            // Si tout s'est bien passé, on s'en va !
            [[self navigationController] popViewControllerAnimated:YES];
        }
    }];
}

- (void)updateDoneButtonStatus
{
	// Le bouton done n'est activé que si on a un nom et un avatar
	BOOL shouldEnableDoneButton = YES;
    
	if ((self.nameTextField.text == nil) || (self.nameTextField.text.length < 1) || (currentAvatar_ == nil)) {
		shouldEnableDoneButton = NO;
	}
    
	self.doneButton.enabled = shouldEnableDoneButton;
}

- (NSString *)title
{
	return NSLocalizedString(@"speakeradd.title", @"");
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self updateDoneButtonStatus];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	[self updateDoneButtonStatus];
	return NO;
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.nameTextField resignFirstResponder];
}
@end
