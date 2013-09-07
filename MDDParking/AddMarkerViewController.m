//
//  AddMarkerViewController.m
//  MDD
//
//  Created by Biranchi on 9/7/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import "AddMarkerViewController.h"
#import "AddNewPlaceViewController.h"
#import "DDAnnotation.h"
#import "DDAnnotationView.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface AddMarkerViewController () <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    DDAnnotation *_annotation;
}
- (void)coordinateChanged_:(NSNotification *)notification;
@end

@implementation AddMarkerViewController

@synthesize mapView = _mapView;


- (void)addNewAnnotationToMap:(CLLocationCoordinate2D)coordinate
{
    // ------------- setting up the pin on user current location
    
    if(!_annotation)
    {
        
        // -------------- zoom in to user current location
        MKCoordinateRegion mapRegion;
        mapRegion.center = coordinate;
        mapRegion.span.latitudeDelta = 0.2;
        mapRegion.span.longitudeDelta = 0.2;
        
        [_mapView setRegion:mapRegion animated:YES];
        
        
        
        // -------------- add draggble pin on to the map
        _annotation = [[DDAnnotation alloc] initWithCoordinate:coordinate addressDictionary:nil];
        _annotation.title = @"Drag to Move Pin";
        _annotation.subtitle = [NSString	stringWithFormat:@"%f %f", _annotation.coordinate.latitude, _annotation.coordinate.longitude];
        
        [self.mapView addAnnotation:_annotation];
        
        
        
        // -------------- show alert message for the first time
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* skipAlertMessage = [defaults objectForKey:@"parking_skip_adding_alert"];
        
        if(skipAlertMessage == nil)
        {
            [defaults setObject:@"YES" forKey:@"parking_skip_adding_alert"];
            [defaults synchronize];
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Information"
                                  message:@"You can drag around the pin for your new parking spot!"
                                  delegate:nil //or self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            
            [alert show];
        }

    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
  self.navigationItem.title = @"Add New Places";
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextBtnAction)];
  self.navigationItem.rightBarButtonItem = addButton;
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    
    
    // ------------- grabbing user current location
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 10;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [_locationManager startUpdatingLocation];
    
}

#pragma mark DDAnnotationCoordinateDidChangeNotification

// NOTE: DDAnnotationCoordinateDidChangeNotification won't fire in iOS 4, use -mapView:annotationView:didChangeDragState:fromOldState: instead.
- (void)coordinateChanged_:(NSNotification *)notification {
	
	DDAnnotation *annotation = notification.object;
	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
}


#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (oldState == MKAnnotationViewDragStateDragging) {
		DDAnnotation *annotation = (DDAnnotation *)annotationView.annotation;
		annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
	}
	
	static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
	MKAnnotationView *draggablePinView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
	
	if (draggablePinView) {
		draggablePinView.annotation = annotation;
	} else {
		// Use class method to create DDAnnotationView (on iOS 3) or built-in draggble MKPinAnnotationView (on iOS 4).
		draggablePinView = [DDAnnotationView annotationViewWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier mapView:self.mapView];
        
		if ([draggablePinView isKindOfClass:[DDAnnotationView class]]) {
			// draggablePinView is DDAnnotationView on iOS 3.
		} else {
			// draggablePinView instance will be built-in draggable MKPinAnnotationView when running on iOS 4.
		}
	}
	
	return draggablePinView;
}


#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    if(location != nil)
    {
        [self addNewAnnotationToMap:location.coordinate];
    }
    
    [_locationManager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"request_error" object:@"Please turn on location services to determine your location." ];
    }
    else if (error.code == kCLErrorLocationUnknown)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"request_error" object:@"Unable to determine current location. Please try again later." ];
    }
    else if(error.code == kCLErrorNetwork)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"request_error" object:@"Having network connection error. Please check your internet connection and try again." ];
    }
        
    [manager stopUpdatingLocation];
}



-(void)nextBtnAction {
  
  AddNewPlaceViewController *addNewPlaceViewController = [[AddNewPlaceViewController alloc] initWithNibName:@"AddNewPlaceViewController" bundle:nil];
  [self.navigationController pushViewController:addNewPlaceViewController animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
