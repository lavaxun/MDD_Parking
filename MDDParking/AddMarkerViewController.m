//
//  AddMarkerViewController.m
//  MDD
//
//  Created by Biranchi on 9/7/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import "AddMarkerViewController.h"
#import "AddNewPlaceViewController.h"
#import <MapKit/MapKit.h>

@interface AddMarkerViewController ()

@end

@implementation AddMarkerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
  self.navigationItem.title = @"Add New Places";
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextBtnAction)];
  self.navigationItem.rightBarButtonItem = addButton;

}


-(void)nextBtnAction {
  
  AddNewPlaceViewController *addNewPlaceViewController = [[AddNewPlaceViewController alloc] initWithNibName:@"AddNewPlaceViewController" bundle:nil];
  [self.navigationController pushViewController:addNewPlaceViewController animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
