//
//  CHLocationPickViewController.m
//  CHParse
//
//  Created by Julien QUERE on 11/02/2014.
//  Copyright (c) 2014 WebD. All rights reserved.
//

#import "CHLocationPickViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
@interface CLPlacemark (CHLocationPickViewController)<MKAnnotation>

@end
@implementation CLPlacemark (CHLocationPickViewController)
- (NSString *)title
{
	return self.locality;
}

- (CLLocationCoordinate2D)coordinate
{
	   
	return self.location.coordinate;
}

@end


@implementation CHLocationPickViewController
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self geocodeAdress:searchBar.text];
}

- (void) geocodeAdress:(NSString*)value {
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    
    NSDictionary * addressDic = @{(NSString *) kABPersonAddressCountryKey : @"France",
                                  (NSString *) kABPersonAddressCityKey:value};

    [self showLoading:YES];
    [geocoder geocodeAddressDictionary:addressDic
                     completionHandler:^(NSArray *placemarks, NSError *error) {
                         if(error) {
                             [self showError:error];
                         } else {
                             [self handleGeocoderResponse:placemarks];
                         }
                     }];
}
- (void) handleGeocoderResponse:(NSArray*) placemarks {
    [self showLoading:NO];
    
    if(displayedItems_) {
        [self.mapView removeAnnotations:displayedItems_];
	}
    displayedItems_ = placemarks;

	[[self mapView] addAnnotations:displayedItems_];
    
    [self zoomMapViewToFitAnnotationsWithExtraZoomToAdjust:0.5];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		return nil;
	}
    
	NSString *reuseIdentifier = @"CityPin";
    
	MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    
	if (!annotationView) {
		annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
        annotationView.canShowCallout = YES;
        annotationView.pinColor     = MKPinAnnotationColorPurple;
        annotationView.animatesDrop              = YES;
	} else {
        [annotationView setAnnotation:annotation];
    }

	return annotationView;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if([self.delegate respondsToSelector:@selector(controller:didSelectPlacemark:)]) {
        
        if([[view annotation] isKindOfClass:[CLPlacemark class]]) {
            [[self delegate] controller:self didSelectPlacemark:(CLPlacemark*)[view annotation]];
        }
    }
}
- (void)zoomMapViewToFitAnnotationsWithExtraZoomToAdjust:(double)extraZoom
{
    if ([[self mapView].annotations count] == 0) return;
    
    int i = 0;
    MKMapPoint points[[[self mapView].annotations count]];
    
    for (id<MKAnnotation> annotation in [[self mapView] annotations])
    {
        points[i++] = MKMapPointForCoordinate(annotation.coordinate);
    }
    
    MKPolygon *poly = [MKPolygon polygonWithPoints:points count:i];
    
    MKCoordinateRegion r = MKCoordinateRegionForMapRect([poly boundingMapRect]);
    r.span.latitudeDelta += extraZoom;
    r.span.longitudeDelta += extraZoom;
    
    [[self mapView] setRegion: r animated:YES];
}

@end
