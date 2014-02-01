//
//  CHSessionDetailsViewController.m
//  CHParse
//
//  Created by Julien on 09/02/2014.
//  Copyright (c) 2014 WebD. All rights reserved.
//

#import "CHSessionDetailsViewController.h"
#import <AsyncImageView.h>
@interface CHSessionDetailsViewController ()

@end

@implementation CHSessionDetailsViewController
- (NSString *)title
{
	return NSLocalizedString(@"sessiondetails.title", @"");
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.titleLabel.text = self.session[@"title"];
    
    NSString * dateString = [[self sessionDateFormatter] stringFromDate:self.session[@"date"]];
	self.dateLabel.text  = [NSString stringWithFormat:@"%@, le %@", self.session[@"city"], dateString];
	[self showLoading:YES];
	[PFObject fetchAllIfNeededInBackground:self.session[@"speakers"]
									 block:^(NSArray *objects, NSError *error) {
                                         if (error) {
                                             [self showError:error];
                                         } else {
                                             speakers_ = objects;
                                             [[self speakersTableVIew] reloadData];
                                             [self showLoading:NO];
                                         }
                                     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [speakers_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	PFObject *speaker = [speakers_ objectAtIndex:indexPath.row];
    
	UILabel     *nameLabel = (UILabel *)[cell viewWithTag:2];
	UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    
	nameLabel.text     = speaker[@"name"];
	imageView.imageURL = [NSURL URLWithString:[(PFFile *)speaker[@"avatar"] url]];
    
	return cell;
}

@end
