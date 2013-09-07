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

@interface PlaceDetailViewController ()
//- (void)configureView;
@end

@implementation PlaceDetailViewController

#pragma mark - Managing the detail item

//- (void)setDetailItem:(id)newDetailItem
//{
//    if (_detailItem != newDetailItem) {
//        _detailItem = newDetailItem;
//        
//        // Update the view.
//        [self configureView];
//    }
//}
//
//- (void)configureView
//{
//    // Update the user interface for the detail item.
//
//	if (self.detailItem) {
//	    self.detailDescriptionLabel.text = [self.detailItem description];
//	}
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	//[self configureView];
	self.navigationItem.title = @"Details";
  
  
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
