//
//  MasterViewController.h
//  MDD
//
//  Created by Biranchi on 9/7/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddingNewPlace.h"

@class PlaceDetailViewController;
@class MKMapView;

@interface PlacesViewController : UIViewController<AddingNewPlaceDelegate>

@property (strong, nonatomic) PlaceDetailViewController *detailViewController;
@property (weak, nonatomic) IBOutlet MKMapView *aMapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
