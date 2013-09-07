//
//  NewPlaceViewController.m
//  MDD
//
//  Created by Biranchi on 9/7/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import "AddNewPlaceViewController.h"

@interface AddNewPlaceViewController ()

@end

@implementation AddNewPlaceViewController

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
  
  self.navigationItem.title = @"Add New Place";
  
  [self createRulesArray];
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction)];
  self.navigationItem.rightBarButtonItem = addButton;
}



-(void)createRulesArray {
  
  rulesArr = [[NSMutableArray alloc] init];
  
  NSMutableDictionary *rulesDict = [NSMutableDictionary dictionaryWithCapacity:0];
  [rulesDict setObject:@"RM 5" forKey:@"FlatRate"];
  [rulesDict setObject:@"RM 2" forKey:@"SubsequentRates"];
  [rulesArr addObject:rulesDict];
  
  rulesDict = [NSMutableDictionary dictionaryWithCapacity:0];
  [rulesDict setObject:@"RM 15" forKey:@"FlatRate"];
  [rulesDict setObject:@"RM 22" forKey:@"SubsequentRates"];
  [rulesArr addObject:rulesDict];
  
  //[rulesArr writeToFile:@"/Users/susantabehera/Desktop/rules.plist" atomically:YES];

}


-(void)doneAction{
  [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)addButtonAction:(id)sender {
  NSLog(@"Add Button Clicked");
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
