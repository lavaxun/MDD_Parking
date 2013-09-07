//
//  MapsViewController.m
//  MDD
//
//  Created by Biranchi on 9/7/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import "MapsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "DDAnnotation.h"
#import "DDAnnotationView.h"
#import "PlaceDetailViewController.h"

@interface MapsViewController ()

@end

@implementation MapsViewController

@synthesize arr;

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
  
	self.navigationItem.title = @"Maps";
  //[self queryGooglePlaces:buttonTitle];
  

  NSLog(@"Location Manager is initialised");
  
  
  //Instantiate a location object.
  locationManager = [[CLLocationManager alloc] init];
  [locationManager setDelegate:self];
  [locationManager setDistanceFilter:10];
  [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
  [locationManager startUpdatingLocation];

}



- (void)addNewAnnotationToMap:(CLLocationCoordinate2D)coordinate
{
  // ------------- setting up the pin on user current location
  
  if(!_annotation)
  {
	
	NSLog(@"Adding anotation view");
	// -------------- zoom in to user current location
	MKCoordinateRegion mapRegion;
	mapRegion.center = coordinate;
	mapRegion.span.latitudeDelta = 0.2;
	mapRegion.span.longitudeDelta = 0.2;
	
	[self.aMapView setRegion:mapRegion animated:YES];
	
	
	
	// -------------- add draggble pin on to the map
	_annotation = [[DDAnnotation alloc] initWithCoordinate:coordinate addressDictionary:nil];
	_annotation.title = @"Parking Spot";
	_annotation.subtitle = [NSString	stringWithFormat:@"%f %f", _annotation.coordinate.latitude, _annotation.coordinate.longitude];
	
	[self.aMapView addAnnotation:_annotation];
	  
  } else {
	NSLog(@"Inside else");
  }
}



#pragma mark Add Parking Spots to Map


-(void)addSurroundingPins:(CLLocationCoordinate2D)coordinate{
  
  for(int i=0; i < 10; i++){
	
	CLLocationCoordinate2D newCoordinate;
	newCoordinate.latitude = coordinate.latitude + (arc4random()%10)/100.0f;
  	newCoordinate.longitude = coordinate.longitude + (arc4random()%10)/100.0f;

	// -------------- add annotation to the map ---------------
	DDAnnotation *annotation = [[DDAnnotation alloc] initWithCoordinate:newCoordinate addressDictionary:nil];
	annotation.title = @"Title";
	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
	
	[self.aMapView addAnnotation:annotation];
  }
}



-(void)addParkingSpotsToMapView {
  
  for(int i=0; i < [self.arr count]; i++ ){
	
	DDAnnotation *annotation = (DDAnnotation *)[self.arr objectAtIndex:i];
	annotation.title = @"Title";
	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
	
	[self.aMapView addAnnotation:annotation];
  }
  
}


#pragma mark Handling Map Tapout

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
  
   //DDAnnotation *location = (DDAnnotation *)view.annotation;
  //NSLog(@"Location Tapped : %@", NSStringFromCGPoint(location.coordinate));
  
  NSLog(@"Annotation Tapped");
  
  PlaceDetailViewController *placeDetailViewController = [[PlaceDetailViewController alloc] initWithNibName:@"PlaceDetailViewController" bundle:nil];
  [self.navigationController pushViewController:placeDetailViewController animated:YES];
}



#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
  
  NSLog(@"Location Manager updated newLocaiton : %f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
  NSLog(@"Location Manager updated oldLocation : %f, %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  CLLocation *location = [locations lastObject];
  
  NSLog(@"Location Manager didUpdateLocations");
  
  if(location != nil)
  {
	[self addNewAnnotationToMap:location.coordinate];
  }
  
  [self addSurroundingPins:location.coordinate];
  //[self addParkingSpotsToMapView];
  
  [locationManager stopUpdatingLocation];
  
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
  
  NSLog(@"Failed with error : %@", [error localizedDescription]);
  
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



#pragma mark - MKMapViewDelegate methods.


- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
  
  //Zoom back to the user location after adding a new set of annotations.
  
  //Get the center point of the visible map.
//  CLLocationCoordinate2D centre = [mv centerCoordinate];
//  MKCoordinateRegion region;
//  region = MKCoordinateRegionMakeWithDistance(centre,50000,50000);
//  [mv setRegion:region animated:YES];
  
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
  
  //Define our reuse indentifier.
  //static NSString *identifier = @"MapPoint";
  
  /*
  if ([annotation isKindOfClass:[MapPoint class]]) {
	
	MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
	if (annotationView == nil) {
	  annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
	} else {
	  annotationView.annotation = annotation;
	}
	
	annotationView.enabled = YES;
	annotationView.canShowCallout = YES;
	annotationView.animatesDrop = YES;
	
	return annotationView;
  }
  
  return nil;
  */
  
  if([annotation isKindOfClass:[MKUserLocation class]])
    return nil;
  
  //8
  static NSString *identifier = @"myAnnotation";
  MKPinAnnotationView * annotationView = (MKPinAnnotationView*)[self.aMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
  if (!annotationView)
  {
	//9
	annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
	
	if(annotation == mapView.userLocation) {
	  annotationView.pinColor = MKPinAnnotationColorGreen;
	} else {
	  annotationView.pinColor = MKPinAnnotationColorPurple;
	}
	//annotationView.image = [UIImage imageNamed:@"arrest.png"];
	annotationView.animatesDrop = YES;
	annotationView.canShowCallout = YES;
  }else {
	annotationView.annotation = annotation;
  }
  annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  return annotationView;
  
  
}

//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
  //return;
  //    //Get the east and west points on the map so we calculate the distance (zoom level) of the current map view.
  //    MKMapRect mRect = self.mapView.visibleMapRect;
  //    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
  //    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
  //
  //    //Set our current distance instance variable.
  //    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
  //
  //    //Set our current centre point on the map instance variable.
  //    currentCentre = self.mapView.centerCoordinate;
//}

//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
//  MKCoordinateRegion region;
//  MKCoordinateSpan span;
//  span.latitudeDelta = 0.005;
//  span.longitudeDelta = 0.005;
//  CLLocationCoordinate2D location;
//  location.latitude = userLocation.coordinate.latitude;
//  location.longitude = userLocation.coordinate.longitude;
//  region.span = span;
//  region.center = location;
//
//}

//- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
//  if (self.onlyOnce) {
//	MKMapRect mRect = self.aMapView.visibleMapRect;
//	MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
//	MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
//	
//	//Set our current distance instance variable.
//	currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
//	currentCentre = self.aMapView.centerCoordinate;
//	//[self queryGooglePlaces:@"Check"];
//  }
//}

#pragma mark -


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
