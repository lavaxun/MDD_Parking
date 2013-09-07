//
//  AddMarkerViewController.h
//  MDD
//
//  Created by Biranchi on 9/7/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AddingNewPlace.h"

@interface AddMarkerViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) id<AddingNewPlaceDelegate> delegate;

@end
