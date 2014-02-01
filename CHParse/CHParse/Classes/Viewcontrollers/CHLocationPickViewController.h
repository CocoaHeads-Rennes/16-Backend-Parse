//
//  CHLocationPickViewController.h
//  CHParse
//
//  Created by Julien QUERE on 11/02/2014.
//  Copyright (c) 2014 WebD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHViewController.h"
#import <MapKit/MapKit.h>
@class CHLocationPickViewController;
@protocol CHLocationPickViewControllerDelegate <NSObject>
- (void) controller:(CHLocationPickViewController*)controller didSelectPlacemark:(CLPlacemark*)placemark;
@end

@interface CHLocationPickViewController : CHViewController <UISearchBarDelegate, MKMapViewDelegate> {
    NSArray * displayedItems_;
}
@property (weak, nonatomic) id<CHLocationPickViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
