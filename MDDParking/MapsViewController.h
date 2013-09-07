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



@interface MapsViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>{
 
  CLLocationManager *locationManager;
  CLLocationCoordinate2D currentCentre;
  BOOL firstLaunch;
  int currenDist;
}

@property (weak, nonatomic) IBOutlet MKMapView *aMapView;
@property(nonatomic, assign) BOOL onlyOnce;
@property (strong, nonatomic) NSArray *arr;

@end
