//
//  NewPlaceViewController.h
//  MDD
//
//  Created by Biranchi on 9/7/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AddingNewPlace.h"

@interface AddNewPlaceViewController : UIViewController {  
}

@property (nonatomic, weak) id<AddingNewPlaceDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (weak, nonatomic) IBOutlet UITextField *name;

@property (weak, nonatomic) IBOutlet UISegmentedControl *weekdayType;
@property (weak, nonatomic) IBOutlet UITextField *weekdayFees;

@property (weak, nonatomic) IBOutlet UISegmentedControl *weekendType;
@property (weak, nonatomic) IBOutlet UITextField *weekendFees;

@property (weak, nonatomic) IBOutlet UISegmentedControl *publicHolidayType;
@property (weak, nonatomic) IBOutlet UITextField *publicHolidayFees;

@end
