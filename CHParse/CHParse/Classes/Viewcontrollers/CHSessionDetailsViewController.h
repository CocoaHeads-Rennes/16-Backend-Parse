//
//  CHSessionDetailsViewController.h
//  CHParse
//
//  Created by Julien on 09/02/2014.
//  Copyright (c) 2014 WebD. All rights reserved.
//

#import "CHViewController.h"

@interface CHSessionDetailsViewController : CHViewController {
	NSArray *speakers_;
}
@property (strong, nonatomic) PFObject           *session;
@property (weak, nonatomic) IBOutlet UILabel     *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel     *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *speakersImageView;
@property (weak, nonatomic) IBOutlet UILabel     *speakersSubtitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *speakersTableVIew;

@end
