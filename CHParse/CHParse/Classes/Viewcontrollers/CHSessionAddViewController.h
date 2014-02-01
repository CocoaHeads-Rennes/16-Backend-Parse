//
//  CHSessionAddViewController.h
//  CHParse
//
//  Created by Julien on 01/02/2014.
//  Copyright (c) 2014 WebD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHViewController.h"
#import "CHSpeakerListViewController.h"
#import "CHLocationPickViewController.h"
@interface CHSessionAddViewController : CHViewController <CHSpeakerListViewControllerDelegate, CHLocationPickViewControllerDelegate, UITextFieldDelegate> {
	NSMutableArray *speakers_;
    CLPlacemark * placemark_;
}
@property (weak, nonatomic) IBOutlet UITextField     *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView      *speakerTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
- (IBAction)doneButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end
