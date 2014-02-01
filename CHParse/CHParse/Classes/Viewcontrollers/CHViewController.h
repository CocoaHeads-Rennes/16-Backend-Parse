//
//  CHViewController.h
//  CHParse
//
//  Created by Julien on 01/02/2014.
//  Copyright (c) 2014 WebD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHViewController : UIViewController {
	NSDateFormatter *sessionDateFormatter_;
}
- (void)showLoading:(BOOL)show;
- (void)setLoadingProgress:(float)progress;
- (NSDateFormatter *)sessionDateFormatter;
- (void)showError:(NSError *)error;
@end
