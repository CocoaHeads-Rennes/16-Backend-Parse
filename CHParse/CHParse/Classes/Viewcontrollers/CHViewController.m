//
//  CHViewController.m
//  CHParse
//
//  Created by Julien on 01/02/2014.
//  Copyright (c) 2014 WebD. All rights reserved.
//

#import "CHViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
@interface CHViewController ()

@end

@implementation CHViewController
- (NSString *)title
{
	return nil;
}

- (NSDateFormatter *)sessionDateFormatter
{
	if (!sessionDateFormatter_) {
		sessionDateFormatter_           = [[NSDateFormatter alloc] init];
		sessionDateFormatter_.dateStyle = NSDateFormatterLongStyle;
	}
    
	return sessionDateFormatter_;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationItem.title = [self title];
}

- (void)showLoading:(BOOL)show
{
	if (show) {
		[SVProgressHUD showWithStatus:[self textForLoading]];
	} else {
		[SVProgressHUD dismiss];
	}
}

- (void)setLoadingProgress:(float)progress
{
	[SVProgressHUD showProgress:progress];
}

- (NSString *)textForLoading
{
	return NSLocalizedString(@"global.loading", @"");
}

- (void)showError:(NSError *)error
{
	if (error) {
		[self showLoading:NO];
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[self titleForError:error]
															message:[self messageForError:error]
														   delegate:nil
												  cancelButtonTitle:NSLocalizedString(@"global.OK", @"")
												  otherButtonTitles:nil];
		[alertView show];
	}
}

- (NSString *)titleForError:(NSError *)error
{
	return NSLocalizedString(@"global.error.title", @"");
}

- (NSString *)messageForError:(NSError *)error
{
	if (error.domain == NSURLErrorDomain) {
		if (error.code == kPFErrorConnectionFailed) {
			return NSLocalizedString(@"global.error.network.offline", @"");
		} else if (error.code == kPFErrorTimeout) {
			return NSLocalizedString(@"global.error.network.timeout", @"");
		} else {
			return NSLocalizedString(@"global.error.network.default", @"");
		}
	}
    
	return NSLocalizedString(@"global.error.subtitle", @"");
}

@end
