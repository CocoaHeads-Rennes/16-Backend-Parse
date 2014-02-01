//
//  CHSpeakerListViewController.m
//  CHParse
//
//  Created by Julien on 01/02/2014.
//  Copyright (c) 2014 WebD. All rights reserved.
//

#import "CHSpeakerListViewController.h"
#import <AsyncImageView.h>
@interface CHSpeakerListViewController ()

@end

@implementation CHSpeakerListViewController

- (void)fetchData
{
	// Vu que l'opération peut prendre du temps, on affiche un loader.
	[self showLoading:YES];
    
	// On construit une requête dans laquelle on demande des objets "Session"
	PFQuery *query = [PFQuery queryWithClassName:@"Speaker"];
	// On veut les résultats triés par date
	[query orderByAscending:@"name"];
    
	// On exécute la requête (en background)
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // Si on a une erreur, on la gère
        if (error) {
            [self showError:error];
        } else {
            // Sinon, on affiche le résultat à l'utilisateur
            [self handleQueryResponse:objects];
        }
    }];
}

- (void)handleQueryResponse:(NSArray *)response
{
	// On récupère le tableau, on le stocke.
	contents_ = response;
	// On retire le loader
	[self showLoading:NO];
	// Et on met à jour la tableView
	[[self tableView] reloadData];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	UILabel         *nameLabel      = (UILabel *)[cell viewWithTag:2];
	UIImageView     *imageView      = (UIImageView *)[cell viewWithTag:1];
    
	//On récupère le speaker à l'index de la cellule
	PFObject *speaker = [contents_ objectAtIndex:indexPath.row];
    
	// On sette le nom
	nameLabel.text = speaker[@"name"];
    
	// Et on récupère le PFFile qui représente l'avatar du speaker
	PFFile *imageFile = (PFFile *)speaker[@"avatar"];
    
	// Et on affiche l'image (via son URL)
	imageView.imageURL = [NSURL URLWithString:[imageFile url]];
    
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [contents_ count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Quand l'utilisateur sélectionne un speaker
	// On prévient le delegate
	// et on fait un pop.
	PFObject *speaker = [contents_ objectAtIndex:indexPath.row];
    
	if ([self.delegate respondsToSelector:@selector(controller:didPickSpeaker:)]) {
		[self.delegate controller:self didPickSpeaker:speaker];
	}
    
	[[self navigationController] popViewControllerAnimated:YES];
}

- (NSString *)title
{
	return NSLocalizedString(@"speakerslist.title", @"");
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self fetchData];
}

@end
