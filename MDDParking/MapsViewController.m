//
//  MapsViewController.m
//  MDD
//
//  Created by Biranchi on 9/7/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import "MapsViewController.h"
#import <MapKit/MapKit.h>

@interface MapsViewController ()

@end

@implementation MapsViewController

@synthesize onlyOnce;

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
  //[locationManager setDistanceFilter:kCLDistanceFilterNone];
  [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
  [locationManager startUpdatingLocation];

  //Set the first launch instance variable to allow the map to zoom on the user location when first launched.
  firstLaunch=YES;
  self.onlyOnce = YES;

}


#pragma mark Current Location Annotation

-(void)addCurrentLocationAnnotation {
  
  CLLocation *currLocation;
  currLocation = [locationManager location];

  MKPointAnnotation *mapPoint = [[MKPointAnnotation alloc] init];
  mapPoint.title = @"Sentul";
  mapPoint.subtitle = @"Kuala Lumpur";
  mapPoint.coordinate = currLocation.coordinate;
  [self.aMapView addAnnotation:mapPoint];

}



#pragma mark Location Manager Delegates

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
  
  NSLog(@"Location Manager updated newLocaiton : %f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
  NSLog(@"Location Manager updated oldLocation : %f, %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);

  //[self addCurrentLocationAnnotation];

  //[manager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  NSLog(@"Location Manager failed : %@", [error localizedDescription]);
}


#pragma mark -


-(void) queryGooglePlaces: (NSString *) googleType
{
  
  
//  NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&name=%@&sensor=true&key=%@", currentCentre.latitude, currentCentre.longitude, [NSString stringWithFormat:@"%i", 50000], @"%22bank%20rakyat%22"/*googleType*/, kGOOGLE_API_KEY];
//  NSLog(@"Type: %@, URL: %@", googleType, url);
//  //Formulate the string as URL object.
//  NSURL *googleRequestURL=[NSURL URLWithString:url];
//  
//  // Retrieve the results of the URL.
//  dispatch_async(kBgQueue, ^{
//	NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
//	[self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
//  });
}

- (void)fetchedData:(NSData *)responseData {
  //parse out the json data
  if (responseData != NULL && responseData.length > 0) {
	NSError* error;
	NSDictionary* json = [NSJSONSerialization
						  JSONObjectWithData:responseData
						  
						  options:kNilOptions
						  error:&error];
	
	//The results from Google will be an array obtained from the NSDictionary object with the key "results".
	NSArray* places = [json objectForKey:@"results"];
	
	//Write out the data to the console.
	NSLog(@"Google Data: %@", places);
	
	//Plot the data in the places array onto the map with the plotPostions method.
	[self plotPositions:places];
  }else {
	//[self.mainDelegate showMessage:@"Network connection is not available on your device to load Map." title:@"Alert"];
  }
}

- (void)plotPositions:(NSArray *)data
{
  //Remove any existing custom annotations but not the user location blue dot.
//  for (id<MKAnnotation> annotation in self.aMapView.annotations)
//  {
//	if ([annotation isKindOfClass:[MKAnnotation class]])
//	{
//	  [self.aMapView removeAnnotation:annotation];
//	}
//  }
  
  
  //Loop through the array of places returned from the Google API.
  for (int i=0; i<[data count]; i++)
  {
	self.onlyOnce = NO;
	//Retrieve the NSDictionary object in each index of the array.
	NSDictionary* place = [data objectAtIndex:i];
	
	//There is a specific NSDictionary object that gives us location info.
	NSDictionary *geo = [place objectForKey:@"geometry"];
	
	
	//Get our name and address info for adding to a pin.
	NSString *name=[place objectForKey:@"name"];
	NSString *vicinity=[place objectForKey:@"vicinity"];
	
	//Get the lat and long for the location.
	NSDictionary *loc = [geo objectForKey:@"location"];
	
	//Create a special variable to hold this coordinate info.
	CLLocationCoordinate2D placeCoord;
	
	//Set the lat and long.
	placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
	placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
	
	//Create a new annotiation.
//	MapPoint *placeObject = [[MapPoint alloc] initWithName:name address:vicinity coordinate:placeCoord];
//	[mapView addAnnotation:placeObject];
  }
}


#pragma mark - MKMapViewDelegate methods.


- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
  
  //Zoom back to the user location after adding a new set of annotations.
  
  //Get the center point of the visible map.
  CLLocationCoordinate2D centre = [mv centerCoordinate];
  
  MKCoordinateRegion region;
  
  //If this is the first launch of the app then set the center point of the map to the user's location.
  if (firstLaunch) {
	region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,currenDist,currenDist);
	firstLaunch=NO;
  }else {
	//Set the center point to the visible region of the map and change the radius to match the search radius passed to the Google query string.
	region = MKCoordinateRegionMakeWithDistance(centre,50000,50000);
  }
  
  //Set the visible region of the map.
  [mv setRegion:region animated:YES];
  
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
	annotationView.pinColor = MKPinAnnotationColorPurple;
	annotationView.animatesDrop = YES;
	annotationView.canShowCallout = YES;
  }else {
	annotationView.annotation = annotation;
  }
  annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  return annotationView;
  
  
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
  return;
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
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  MKCoordinateRegion region;
  MKCoordinateSpan span;
  span.latitudeDelta = 0.005;
  span.longitudeDelta = 0.005;
  CLLocationCoordinate2D location;
  location.latitude = userLocation.coordinate.latitude;
  location.longitude = userLocation.coordinate.longitude;
  region.span = span;
  region.center = location;
  //[self.mapView setRegion:region animated:YES];
  
  //    MKMapRect mRect = self.mapView.visibleMapRect;
  //    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
  //    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
  //
  //    //Set our current distance instance variable.
  //    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
  //    currentCentre = self.mapView.centerCoordinate;
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
  if (self.onlyOnce) {
	MKMapRect mRect = self.aMapView.visibleMapRect;
	MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
	MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
	
	//Set our current distance instance variable.
	currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
	currentCentre = self.aMapView.centerCoordinate;
	//[self queryGooglePlaces:@"Check"];
  }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
