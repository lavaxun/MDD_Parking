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
#import <MapKit/MapKit.h>

@interface PlacesViewController () {
    NSMutableArray *arr;
}
@end

@implementation PlacesViewController

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
  
  
  arr = [[NSMutableArray alloc] init];
  for(int i=0; i < 10; i ++){
	[arr addObject:[NSString stringWithFormat:@"%d", i]];
  }
  

	//------------Add Button ----------
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPlaces)];
	self.navigationItem.rightBarButtonItem = addButton;
}


-(void)showMapViewController {
	
  MapsViewController *mapsViewController = [[MapsViewController alloc] initWithNibName:@"MapsViewController" bundle:nil];
  [self.navigationController pushViewController:mapsViewController animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addPlaces{
 
  AddMarkerViewController *addMarkerViewController = [[AddMarkerViewController alloc] initWithNibName:@"AddMarkerViewController" bundle:nil];
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
	return [arr count];
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
	cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
  return 100.0f;
}


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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[PlaceDetailViewController alloc] initWithNibName:@"PlaceDetailViewController" bundle:nil];
    }
    //NSDate *object = _objects[indexPath.row];
    //self.detailViewController.detailItem = object;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}
 

@end




