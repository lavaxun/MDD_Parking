//
//  DetailViewController.m
//  MDD
//
//  Created by Biranchi on 9/7/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import "PlaceDetailViewController.h"
#import <MapKit/MapKit.h>
#import "AddNewPlaceViewController.h"
#import "MDDParkingSpot.h"
#import "MDDFee.h"

@interface PlaceDetailViewController ()
//- (void)configureView;
@end

@implementation PlaceDetailViewController

@synthesize parkingSpotObj;

#pragma mark - Managing the detail item


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	//[self configureView];
	self.navigationItem.title = @"Details";

}

- (void)viewWillAppear:(BOOL)animated
{
    if(self.parkingSpotObj){
		self.parkingSpotNameLbl.text = self.parkingSpotObj.name;
		
		
		NSString *str = @"";
		MDDFee *mddFee = nil;
		float parkingFee = 0.0f;
		NSString *type = @"";
        
		for(int i=0; i < [self.parkingSpotObj.fees count]; i++){
            
			mddFee = [self.parkingSpotObj.fees objectAtIndex:i];
			parkingFee =  mddFee.fee;
            
			if(parkingFee == 0.0f){
                type = [NSString stringWithFormat:@"%@",mddFee.type];
			} else {
                type = [NSString stringWithFormat:@"RM %0.2f %@", parkingFee, mddFee.type];
			}
			
			str = [NSString stringWithFormat:@"%@%@ %@\n\n",str, mddFee.rule, type];
			
		}
        
        NSLog(@"str : %@", str);
        self.parkingRuleLbl.text = str;
	}
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
@end
