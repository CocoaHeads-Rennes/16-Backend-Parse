//
//  CHSessionListViewController.h
//  CHParse
//
//  Created by Julien on 01/02/2014.
//  Copyright (c) 2014 WebD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHViewController.h"
@interface CHSessionListViewController : CHViewController <UITableViewDataSource, UITableViewDelegate> {
	NSArray         *contents_;
	NSDateFormatter *cellDateFormatter_;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
