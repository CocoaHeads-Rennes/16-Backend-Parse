//
//  CHSessionListViewController.m
//  CHParse
//
//  Created by Julien on 01/02/2014.
//  Copyright (c) 2014 WebD. All rights reserved.
//

#import "CHSessionListViewController.h"
#import "CHSessionDetailsViewController.h"
@interface CHSessionListViewController ()

@end

@implementation CHSessionListViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	// À l'apparition, on va récupérer la liste des sessions
	[self fetchData];
}

- (void)fetchData
{
	// Vu que l'opération peut prendre du temps, on affiche un loader.
	[self showLoading:YES];
    
	// On construit une requête dans laquelle on demande des objets "Session"
	PFQuery *query = [PFQuery queryWithClassName:@"Session"];
	// On veut les résultats triés par date
	[query orderByAscending:@"date"];
    
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
    
	//On récupère la session à l'index de la cellule
	PFObject *session = [contents_ objectAtIndex:indexPath.row];
    
	// Le champ date
	NSDate *sessionDate = session[@"date"];
    
	// Le champ title
	cell.textLabel.text       = session[@"title"];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ | %@", session[@"city"], [[self sessionDateFormatter] stringFromDate:sessionDate]];

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	// Ici, il s'agit simplement de transmettre la session sélectionnée au CHSessionDetailsViewController
	if ([segue.identifier isEqualToString:@"sessiondetails"]) {
		if ([segue.destinationViewController isKindOfClass:[CHSessionDetailsViewController class]]) {
			if ([sender isKindOfClass:[UITableViewCell class]]) {
				NSIndexPath *indexPath = [[self tableView] indexPathForCell:sender];
				PFObject    *session   = [contents_ objectAtIndex:indexPath.row];
				[(CHSessionDetailsViewController *)segue.destinationViewController setSession : session];
			}
		}
	}
}

- (NSString *)title
{
	return NSLocalizedString(@"sessionlist.title", @"");
}

@end
