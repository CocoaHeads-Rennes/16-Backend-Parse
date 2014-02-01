//
//  CHSpeakerListViewController.h
//  CHParse
//
//  Created by Julien on 01/02/2014.
//  Copyright (c) 2014 WebD. All rights reserved.
//

#import "CHViewController.h"
@class CHSpeakerListViewController;
@protocol CHSpeakerListViewControllerDelegate <NSObject>
- (void)controller:(CHSpeakerListViewController *)controller didPickSpeaker:(PFObject *)speaker;
@end

@interface CHSpeakerListViewController : CHViewController {
	NSArray *contents_;
}
@property (weak, nonatomic) IBOutlet UITableView                   *tableView;
@property (weak, nonatomic) id<CHSpeakerListViewControllerDelegate> delegate;
@end
