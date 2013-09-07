//
//  DetailViewController.h
//  MDD
//
//  Created by Biranchi on 9/7/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDDParkingSpot;
@interface PlaceDetailViewController : UIViewController {
  
}

@property (strong, nonatomic) MDDParkingSpot *parkingSpotObj;
@property (weak, nonatomic) IBOutlet UILabel *parkingSpotNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *parkingRuleLbl;


@end
