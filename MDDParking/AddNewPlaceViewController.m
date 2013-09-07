//
//  NewPlaceViewController.m
//  MDD
//
//  Created by Biranchi on 9/7/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import "AddNewPlaceViewController.h"
#import "MDDParkingSpot.h"
#import "MDDFee.h"


@interface AddNewPlaceViewController ()<UITextFieldDelegate>
{
    CGFloat kbHeight;
    CGFloat kbTop;
    UITextField *activeField;
}
@end

@implementation AddNewPlaceViewController

@synthesize coordinate = _coordinate;
@synthesize delegate = _delegate;

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
  
    
    
    self.weekdayFees.delegate = self;
    self.weekendFees.delegate = self;
    self.publicHolidayFees.delegate = self;
    self.name.delegate = self;

    
    
  self.navigationItem.title = @"Add New Place";
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];
  self.navigationItem.rightBarButtonItem = addButton;
    
    
    [self registerForKeyboardNotifications];
}
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
    activeField = textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return !([[textField text] length] + (string.length - range.length) > 99);// not more than 99 characters
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
        return NO;
    }
    
    [textField resignFirstResponder];
    [self doneAction];
    
    return YES;
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        [_scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}


-(void)doneAction{
    
    if( [self.name.text length] >1 )
    {
        
        NSString* weekdayData;
        
        if(self.weekdayFees.enabled)
        {
            weekdayData = [self.weekdayType titleForSegmentAtIndex:[self.weekdayType selectedSegmentIndex]];
        }
        else
        {
            weekdayData = @"Free";
        }
        
        NSString* weekendData;
        
        if(self.weekendType.enabled)
        {
            weekendData = [self.weekendType titleForSegmentAtIndex:[self.weekendType selectedSegmentIndex]];
        }
        else
        {
            weekendData = @"Free";
        }
        
        
        NSString* publicHolidayData;
        
        if(self.publicHolidayFees.enabled)
        {
            publicHolidayData = [self.publicHolidayType titleForSegmentAtIndex:[self.publicHolidayType selectedSegmentIndex]];
        }
        else
        {
            publicHolidayData = @"Free";
        }
        
        
    NSDictionary *dict = @{
                           @"id": @(12313),
                           @"name": self.name.text,
                           @"lat" : @(self.coordinate.latitude),
                           @"lng" : @(self.coordinate.longitude),
                           @"fees" : @[
                                       @{
                                           @"type" : weekdayData,
                                           @"rule" : @"Weekdays",
                                           @"fee" : self.weekdayFees.text
                                       },
                                       @{
                                           @"type" : weekendData,
                                           @"rule" : @"Weekend",
                                           @"fee" : self.weekendFees.text
                                        },
                                       @{
                                           @"type" : publicHolidayData,
                                           @"rule" : @"Public Holiday",
                                           @"fee" : self.publicHolidayFees.text
                                        },

                                   ]
                           };

    
    MDDParkingSpot * newSpot = [[MDDParkingSpot alloc] initWithAttributes:dict];
    
    [self.delegate addNewParkingSpot:newSpot];
    NSLog(@"created a new parking spot");
  [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Warning"
                              message:@"The new parking spot name should not be empty."
                              delegate:nil //or self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        
        [alert show];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)weekdaysRateChanged:(id)sender {
    if([self.weekdayType selectedSegmentIndex] == 2)    // free
    {
        [self.weekdayFees setEnabled:NO];
    }
    else
    {
        [self.weekdayFees setEnabled:YES];
    }
}

- (IBAction)weekendRateChanged:(id)sender {
    if([self.weekendType selectedSegmentIndex] == 2)    // free
    {
        [self.weekendFees setEnabled:NO];
    }
    else
    {
        [self.weekendFees setEnabled:YES];
    }
}

- (IBAction)publicHolidayRateChanged:(id)sender {
    if([self.publicHolidayType selectedSegmentIndex] == 2)    // free
    {
        [self.publicHolidayFees setEnabled:NO];
    }
    else
    {
        [self.publicHolidayFees setEnabled:YES];
    }
}


@end
