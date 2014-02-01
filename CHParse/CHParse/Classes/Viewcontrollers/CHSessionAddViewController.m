//
//  CHSessionAddViewController.m
//  CHParse
//
//  Created by Julien on 01/02/2014.
//  Copyright (c) 2014 WebD. All rights reserved.
//

#import "CHSessionAddViewController.h"

@interface CHSessionAddViewController ()

@end

@implementation CHSessionAddViewController

- (IBAction)doneButtonAction:(id)sender
{
	// On crée un objet de classe Session
	PFObject *session = [PFObject objectWithClassName:@"Session"];
    
	// Il suffit de setter tous les champs
	session[@"title"]    = self.titleTextField.text;
	session[@"date"]     = self.datePicker.date;
	session[@"speakers"] = speakers_;
    session[@"city"] = placemark_.locality;
    session[@"location"] = [PFGeoPoint geoPointWithLocation:placemark_.location];
	// Et on va sauvegarder l'objet ... Comme ça prend un peu de temps, on affiche un loader
	[self showLoading:YES];
	[session saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // Si tout s'est bien passé, on ferme le vc modal.
        if (succeeded) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            // Sinon, on gère l'erreur
            [self showError:error];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	// Avant de lancer le CHSpeakerListViewController, on se met en tant que delegate
	if ([segue.identifier isEqualToString:@"speaker_pick"]) {
		if ([segue.destinationViewController isKindOfClass:[CHSpeakerListViewController class]]) {
			[(CHSpeakerListViewController *)segue.destinationViewController setDelegate : self];
		}
	} else if([segue.identifier isEqualToString:@"location_pick"]) {
        if ([segue.destinationViewController isKindOfClass:[CHLocationPickViewController class]]) {
			[(CHLocationPickViewController *)segue.destinationViewController setDelegate : self];
		}
    }
}

- (void)controller:(CHSpeakerListViewController *)controller didPickSpeaker:(PFObject *)speaker
{
	// Quand l'utilisateur a sélectionné un speaker,
	// on l'ajoute à la liste courante (en n'oubliant pas
	// de mettre à jour la speakerTextView)
	if (!speakers_) {
		speakers_ = [NSMutableArray array];
	}
    
	[speakers_ addObject:speaker];
	[self updateSpeakersTextView];
}

- (void)updateSpeakersTextView
{
	NSString *textViewValue = nil;
    
	// Le texte est une simple concaténation des nom des speakers
	for (PFObject *speaker in speakers_) {
		if (textViewValue != nil) {
			textViewValue = [NSString stringWithFormat:@"%@\n%@", textViewValue, speaker[@"name"]];
		} else {
			textViewValue = speaker[@"name"];
		}
	}
    
	self.speakerTextView.text = textViewValue;
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    // Avant le lancement, on met à jour l'état du bouton "done"
    // et du speakerTextView
	[self updateDoneButtonStatus];
	[self updateSpeakersTextView];

    self.locationLabel.text = placemark_.locality;
    
}

- (void)updateDoneButtonStatus
{
    // Le bouton "done" ne doit être activé que si
    // on a un titre et au moins 1 speaker
	BOOL enabled = YES;
    
	if (self.titleTextField.text.length == 0) {
		enabled = NO;
	} else if (!speakers_ || ([speakers_  count] < 1)) {
		enabled = NO;
	} else if(!placemark_) {
        enabled = NO;
    }
    
	self.doneButton.enabled = enabled;
}
- (void) controller:(CHLocationPickViewController*)controller didSelectPlacemark:(CLPlacemark*)placemark {
    placemark_ = placemark;
    [self updateDoneButtonStatus];
    [[self navigationController] popToViewController:self animated:YES];
}


- (NSString *)title
{
	return NSLocalizedString(@"sessionadd.title", @"");
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self.titleTextField addTarget:self
							action:@selector(updateDoneButtonStatus)
				  forControlEvents:UIControlEventEditingChanged];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	[self updateDoneButtonStatus];
	return NO;
}

- (IBAction)cancelButtonAction:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.titleTextField resignFirstResponder];
}
@end
