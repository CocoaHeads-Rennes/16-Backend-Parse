//
//  CHSpeakerAddViewController.h
//  CHParse
//
//  Created by Julien on 01/02/2014.
//  Copyright (c) 2014 WebD. All rights reserved.
//

#import "CHViewController.h"
@class CHSpeakerAddViewController;

@interface CHSpeakerAddViewController : CHViewController <UITextFieldDelegate> {
	UIImage *currentAvatar_;
}
@property (weak, nonatomic) IBOutlet UITextField     *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton        *imageButton;
@property (weak, nonatomic) IBOutlet UIImageView     *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
- (IBAction)doneButtonAction:(id)sender;
- (IBAction)imageButtonAction:(id)sender;

@end
