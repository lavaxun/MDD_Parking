//
//  MapsViewController.h
//  MDD
//
//  Created by Biranchi on 9/7/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AddingNewPlace.h"

@class DDAnnotation;
@interface MapsViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>{
 
  CLLocationManager *locationManager;
  DDAnnotation *_annotation;

}

@property (nonatomic, weak) id<AddingNewPlaceDelegate> delegate;
@property (weak, nonatomic) IBOutlet MKMapView *aMapView;
@property (strong, nonatomic) NSArray *arr;

@end
