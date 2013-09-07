//
//  MasterViewController.m
//  MDD
//
//  Created by Biranchi on 9/7/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import "PlacesViewController.h"
#import "PlaceDetailViewController.h"
#import "AddMarkerViewController.h"
#import "MapsViewController.h"
#import "MDDParkingSpot.h"
#import "MDDFee.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MDDAnnotation.h"


@interface PlacesViewController ()<CLLocationManagerDelegate> {
    CLLocationManager *_locationManager;
    int _selectedRow;
}
@end

@implementation PlacesViewController

@synthesize arr = _arr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.navigationItem.title = @"Places";
  
  
  //------------Tap Gestures  ----------

  UITapGestureRecognizer *tapGestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMapViewController)];
  [self.aMapView setUserInteractionEnabled:YES];
  [self.aMapView addGestureRecognizer:tapGestureRecogniser];
    [self.aMapView showsUserLocation];
//    self.aMapView.delegate = self;
//    [self.aMapView showsUserLocation:YES];
    
  if(!_arr)
      _arr = [NSArray array];

	//------------Add Button ----------
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPlaces)];
	self.navigationItem.rightBarButtonItem = addButton;
    
    
    // ------------- grabbing user current location
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 10;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [_locationManager startUpdatingLocation];

    
    [self.tableView reloadData];
}

#pragma mark -




-(NSMutableArray *)getAnnotationsArr{
  
  NSMutableArray *annotationsArr = [NSMutableArray arrayWithCapacity:0];
  MDDAnnotation *annotation = nil;
  CLLocationCoordinate2D coordinate;
  
  NSArray *feesArr	  = nil;
  MDDFee *mddFee	  = nil;
  float parkingFee	  = 0.0f;
  NSString *type	  = @"";
  NSString *str		  = @"";
  
  
  for(int i=0; i < [_arr count]; i++){
	
	annotation = [[MDDAnnotation alloc] init];
	
	coordinate.latitude = [[_arr objectAtIndex:i] lat];
	coordinate.longitude = [[_arr objectAtIndex:i] lng];
	
	NSLog(@"Lat : %f, Lng : %f", coordinate.latitude, coordinate.longitude);
	
	annotation.coordinate = coordinate;
	annotation.title = [[_arr objectAtIndex:i] name];
	
	feesArr = [[_arr objectAtIndex:i] fees];
	if(feesArr && [feesArr count]){
	  
		mddFee = [[[_arr objectAtIndex:i] fees] objectAtIndex:0];
		if(mddFee){
			parkingFee =  mddFee.fee;
			
			if(parkingFee == 0.0f){
			  type = [NSString stringWithFormat:@"%@",mddFee.type];
			} else {
			  type = [NSString stringWithFormat:@"RM %0.2f %@", parkingFee, mddFee.type];
			}
			str = [NSString stringWithFormat:@"%@ %@", mddFee.rule, type];
			
			annotation.subtitle = str;
		}
	  
	}

	annotation.objectX = [_arr objectAtIndex:i];	
	[annotationsArr addObject:annotation];
  }
  
  return annotationsArr;
}




-(void)showMapViewController {

  NSMutableArray *annotationsArr = [self getAnnotationsArr];
  
  MapsViewController *mapsViewController = [[MapsViewController alloc] initWithNibName:@"MapsViewController" bundle:nil];
	mapsViewController.arr = annotationsArr;
    mapsViewController.delegate = self;
  [self.navigationController pushViewController:mapsViewController animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addPlaces{
 
  AddMarkerViewController *addMarkerViewController = [[AddMarkerViewController alloc] initWithNibName:@"AddMarkerViewController" bundle:nil];
    addMarkerViewController.delegate = self;
  [self.navigationController pushViewController:addMarkerViewController animated:YES];
    
}

//- (void)insertNewObject:(id)sender
//{
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    [_objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_arr count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }


	//NSDate *object = _objects[indexPath.row];
	cell.textLabel.text = [[_arr objectAtIndex:indexPath.row] name];
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
  return 100.0f;
}

/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[_objects removeObjectAtIndex:indexPath.row];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
  
	self.detailViewController.delegate = self;

        self.detailViewController = [[PlaceDetailViewController alloc] initWithNibName:@"PlaceDetailViewController" bundle:nil];
        self.detailViewController.delegate = self;
    //NSDate *object = _objects[indexPath.row];
    //self.detailViewController.detailItem = object;
	MDDParkingSpot *mddParkingSpot = (MDDParkingSpot *)[self.arr objectAtIndex:indexPath.row];
    _selectedRow = [indexPath row];
	self.detailViewController.parkingSpotObj = mddParkingSpot;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}


#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    if(location != nil)
    {
        // -------------- zoom in to user current location
        MKCoordinateRegion mapRegion;
        mapRegion.center = location.coordinate;
        mapRegion.span.latitudeDelta = 0.2;
        mapRegion.span.longitudeDelta = 0.2;
        
        [self.aMapView setRegion:mapRegion animated:YES];
        
        __weak typeof(self) weakMaster = self;
        
        [MDDParkingSpot nearestParkingSpotsWithBlock:^(NSArray *posts, NSError *error) {
            if (error)
            {
                NSLog(@"something goes wrong in here. it may relates to the places-get.json file.");
            }
            else
            {
                weakMaster.arr = posts;
                [weakMaster.tableView reloadData];
            }
        } atCoordinate:location.coordinate];
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



#pragma adding new place delegate
- (void)addNewParkingSpot:(MDDParkingSpot*)place
{
    [MDDParkingSpot addNewParkingSpotsWithBlock:^(MDDParkingSpot *post, NSError *error) {
        NSLog(@"posted : %f, %f", post.lat, post.lng);

        NSMutableArray *mutable = [NSMutableArray arrayWithArray:_arr];
        [mutable addObject:post];
        _arr = [NSArray arrayWithArray:mutable];
        [self.tableView reloadData];

    } byUsing:place];
    
}

- (void)editParkingSpot:(MDDParkingSpot*)place andUpdateTo:(MDDParkingSpot*)target
{
//    __block MDDParkingSpot* weakTarget = target;
    [MDDParkingSpot editParkingSpotsWithBlock:^(MDDParkingSpot *post, NSError *error) {

        NSMutableArray* mut = [NSMutableArray arrayWithArray:self.arr];
        [mut setObject:post atIndexedSubscript:_selectedRow];
        self.arr = [NSArray arrayWithArray:mut];
//        self.arr
//        NSMutableArray *mutable = [NSMutableArray arrayWithArray:_arr];
///        [mutable addObject:post];
//        _arr = [NSArray arrayWithArray:mutable];
        [self.tableView reloadData];
        
    } byUsing:place];
    
}

@end




