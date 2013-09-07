//
//  DetailViewController.h
//  MDD
//
//  Created by Biranchi on 9/7/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddingNewPlace.h"

@class MDDParkingSpot;
@interface PlaceDetailViewController : UIViewController {
  
}

@property (nonatomic, weak) id<AddingNewPlaceDelegate> delegate;
@property (strong, nonatomic) MDDParkingSpot *parkingSpotObj;
@property (weak, nonatomic) IBOutlet UITextField *parkingSpotName;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UISegmentedControl *weekdaysRateType;
@property (weak, nonatomic) IBOutlet UITextField *weekdaysRateFee;
- (IBAction)weekdaysRateChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *weekendRateType;
@property (weak, nonatomic) IBOutlet UITextField *weekendRateFee;
- (IBAction)weekendRateChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *publicHolidayType;
@property (weak, nonatomic) IBOutlet UITextField *publicHolidayFee;
- (IBAction)publicHolidayRateChanged:(id)sender;



@end
