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
{
    CGFloat kbHeight;
    CGFloat kbTop;
    UITextField *activeField;
    int _currentState;

	UIBarButtonItem *_editButton;
    UIBarButtonItem *_backButton;
    UIBarButtonItem *_cancelButton;
}

@synthesize parkingSpotObj;
@synthesize scrollView = _scrollView;
#pragma mark - Managing the detail item


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	//[self configureView];
	self.navigationItem.title = @"Details";
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    [self registerForKeyboardNotifications];
    
    _currentState = 0;
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editAction)];
    self.navigationItem.rightBarButtonItem = editButton;

    [self registerForKeyboardNotifications];
    
    _currentState = 1;
    
    _editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editAction)];
    self.navigationItem.rightBarButtonItem = _editButton;
    
    _cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelAction)];

    
    _backButton = self.navigationItem.leftBarButtonItem;

    [self checkCurrentState];
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
//    [self doneAction];
    
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



-(int)checkSelectedIndex:(NSString*)string
{
  if([string isEqualToString:@"Per hour"])
    {
        return 1;
    }
    else if([string isEqualToString:@"Free"])
    {
        return 2;
    }
    else return 0;

}


- (void)viewWillAppear:(BOOL)animated
{
    if(self.parkingSpotObj){
		self.parkingSpotName.text = self.parkingSpotObj.name;
		      
		for(int i=0; i < [self.parkingSpotObj.fees count]; i++){
            
			MDDFee * mddFee = [self.parkingSpotObj.fees objectAtIndex:i];
            
            if( ([mddFee rule]) && [[mddFee rule] isEqualToString:@"Weekdays"])
            {
                self.weekdaysRateFee.text = [NSString stringWithFormat:@"%.2f",[mddFee fee]];
                [self.weekdaysRateType setSelectedSegmentIndex:[self checkSelectedIndex:[mddFee type]]];
                
//                if( [self checkSelectedIndex:[mddFee type]] == 2)
//                    self.weekdaysRateFee.enabled = NO;
//                else
//                    self.weekdaysRateFee.enabled = YES;
            }
            else if( ([mddFee rule]) && [[mddFee rule] isEqualToString:@"Weekend"])
            {
                self.weekendRateFee.text = [NSString stringWithFormat:@"%.2f",[mddFee fee]];
                [self.weekendRateType setSelectedSegmentIndex:[self checkSelectedIndex:[mddFee type]]];
                
//                if( [self checkSelectedIndex:[mddFee type]] == 2)
//                    self.weekendRateFee.enabled = NO;
//                else
//                    self.weekendRateFee.enabled = YES;

            }
            else if( ([mddFee rule]) && [[mddFee rule] isEqualToString:@"Public Holiday"])
            {
                self.publicHolidayFee.text = [NSString stringWithFormat:@"%.2f",[mddFee fee]];
                [self.publicHolidayType setSelectedSegmentIndex:[self checkSelectedIndex:[mddFee type]]];
                
//                if( [self checkSelectedIndex:[mddFee type]] == 2)
//                    self.publicHolidayFee.enabled = NO;
//                else
//                    self.publicHolidayFee.enabled = YES;

            }
			
		}
        
	}
}

-(void)editAction{
    
    if( [self.parkingSpotName.text length] >1 )
    {
        NSString* weekdayData;
        
        if(self.weekdaysRateFee.enabled)
        {
            weekdayData = [self.weekdaysRateType titleForSegmentAtIndex:[self.weekdaysRateType selectedSegmentIndex]];
        }
        else
        {
            weekdayData = @"Free";
        }
        
        NSString* weekendData;
        
        if(self.weekendRateFee.enabled)
        {
            weekendData = [self.weekendRateType titleForSegmentAtIndex:[self.weekendRateType selectedSegmentIndex]];
        }
        else
        {
            weekendData = @"Free";
        }
        
        
        NSString* publicHolidayData;
        
        if(self.publicHolidayFee.enabled)
        {
            publicHolidayData = [self.publicHolidayType titleForSegmentAtIndex:[self.publicHolidayType selectedSegmentIndex]];
        }
        else
        {
            publicHolidayData = @"Free";
        }
        
        NSDictionary *dict = @{
                               @"id": @(self.parkingSpotObj.id),
                               @"name": self.parkingSpotName.text,
                               @"lat" : @(self.parkingSpotObj.lat),
                               @"lng" : @(self.parkingSpotObj.lng),
                               };

        NSMutableDictionary* mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        NSMutableArray* mutableList = [NSMutableArray arrayWithCapacity:0];
        int looperIndex = 0;
        for(MDDFee* fee in self.parkingSpotObj.fees)
        {
            NSDictionary * tempDict;
            
            if([fee.rule isEqualToString:@"Weekdays"])
            {
                tempDict = @{ @"id"   : @(fee.id),
                              @"type" : weekdayData,
                              @"rule" : fee.rule,
                              @"fee" : self.weekdaysRateFee.text,
                                         };
            }
            else if([fee.rule isEqualToString:@"Weekend"])
            {
                tempDict = @{ @"id"   : @(fee.id),
                              @"type" : weekendData,
                              @"rule" : fee.rule,
                              @"fee" : self.weekendRateFee.text,
                              };
                
            }
            else if([fee.rule isEqualToString:@"Public Holiday"])
            {
                tempDict = @{ @"id"   : @(fee.id),
                              @"type" : publicHolidayData,
                              @"rule" : fee.rule,
                              @"fee" : self.publicHolidayFee.text,
                              };
                
            }

            
            [mutableList addObject:tempDict];
            //[mutableDict addEntriesFromDictionary:tempDict];
            ++looperIndex;
        }
        
        [mutableDict addEntriesFromDictionary:@{@"fees":mutableList}];
        
        MDDParkingSpot * newSpot = [[MDDParkingSpot alloc] initWithAttributes:[NSDictionary dictionaryWithDictionary:mutableDict]];
        [self.delegate editParkingSpot:newSpot andUpdateTo:self.parkingSpotObj];
        NSLog(@"edited a new parking spot");
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
    
- (void)checkCurrentState
{
    // if editing
    if(_currentState == 0)
    {
        self.parkingSpotName.userInteractionEnabled = YES;
        self.weekdaysRateFee.userInteractionEnabled = YES;
        self.weekendRateFee.userInteractionEnabled = YES;
        self.publicHolidayFee.userInteractionEnabled = YES;
        self.weekdaysRateType.userInteractionEnabled = YES;
        self.weekendRateType.userInteractionEnabled = YES;
        self.publicHolidayType.userInteractionEnabled = YES;
        
    }
    else
    {
        self.parkingSpotName.userInteractionEnabled = NO;
        self.weekdaysRateFee.userInteractionEnabled = NO;
        self.weekendRateFee.userInteractionEnabled = NO;
        self.publicHolidayFee.userInteractionEnabled = NO;
        self.weekdaysRateType.userInteractionEnabled = NO;
        self.weekendRateType.userInteractionEnabled = NO;
        self.publicHolidayType.userInteractionEnabled = NO;
    }
}

-(void)cancelAction{
    _currentState = 1;
    [_editButton setStyle:UIBarButtonItemStyleBordered];
    [_editButton setTitle:@"Edit"];
    self.navigationItem.leftBarButtonItem = _backButton;
    
    [self checkCurrentState];
}

-(void)editAction{
    
    _currentState = (_currentState == 1)?0:1;
    
        [self checkCurrentState];
    if(_currentState == 1)
    {
        [_editButton setStyle:UIBarButtonItemStyleBordered];
        [_editButton setTitle:@"Edit"];
        
        if( [self.parkingSpotName.text length] >1 )
        {
            NSString* weekdayData;
            
            if(self.weekdaysRateFee.enabled)
            {
                weekdayData = [self.weekdaysRateType titleForSegmentAtIndex:[self.weekdaysRateType selectedSegmentIndex]];
            }
            else
            {
                weekdayData = @"Free";
            }
            
            NSString* weekendData;
            
            if(self.weekendRateFee.enabled)
            {
                weekendData = [self.weekendRateType titleForSegmentAtIndex:[self.weekendRateType selectedSegmentIndex]];
            }
            else
            {
                weekendData = @"Free";
            }
            
            
            NSString* publicHolidayData;
            
            if(self.publicHolidayFee.enabled)
            {
                publicHolidayData = [self.publicHolidayType titleForSegmentAtIndex:[self.publicHolidayType selectedSegmentIndex]];
            }
            else
            {
                publicHolidayData = @"Free";
            }
            
            NSDictionary *dict = @{
                                   @"id": @(self.parkingSpotObj.id),
                                   @"name": self.parkingSpotName.text,
                                   @"lat" : @(self.parkingSpotObj.lat),
                                   @"lng" : @(self.parkingSpotObj.lng),
                                   };

            NSMutableDictionary* mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            NSMutableArray* mutableList = [NSMutableArray arrayWithCapacity:0];
            
            
            
            int occupied = 0;
            
            if(self.parkingSpotObj.fees)
            {
                if(([self.parkingSpotObj.fees count] > 0))
                {
                    occupied = [self.parkingSpotObj.fees count];
                }
            }
            
            BOOL weekdayTaken = NO;
            BOOL weekendTaken = NO;
            BOOL publicHolidayTaken = NO;
            
            
            for( int ii = 0; ii < 3; ii++ )
            {
                NSDictionary * tempDict;
                
                if( ii < occupied )
                {
                    MDDFee* fee = [self.parkingSpotObj.fees objectAtIndex:ii];
                    
                    if([fee.rule isEqualToString:@"Weekdays"])
                    {
                        tempDict = @{ @"id"   : @(fee.id),
                                      @"type" : weekdayData,
                                      @"rule" : fee.rule,
                                      @"fee" : self.weekdaysRateFee.text,
                                                 };
                        weekdayTaken = YES;
                    }
                    else if([fee.rule isEqualToString:@"Weekend"])
                    {
                        tempDict = @{ @"id"   : @(fee.id),
                                      @"type" : weekendData,
                                      @"rule" : fee.rule,
                                      @"fee" : self.weekendRateFee.text,
                                      };
                        weekendTaken = YES;
                    }
                    else if([fee.rule isEqualToString:@"Public Holiday"])
                    {
                        tempDict = @{ @"id"   : @(fee.id),
                                      @"type" : publicHolidayData,
                                      @"rule" : fee.rule,
                                      @"fee" : self.publicHolidayFee.text,
                                      };
                        publicHolidayTaken = YES;
                    }
                }
                else
                {
                    if(!weekdayTaken)
                    {
                        tempDict = @{ @"id"   : @"",
                                      @"type" : weekdayData,
                                      @"rule" : @"Weekdays",
                                      @"fee" : self.weekdaysRateFee.text,
                                      };
                        weekdayTaken = YES;
                    }
                    else                 if(!weekendTaken)
                    {
                        tempDict = @{ @"id"   : @"",
                                      @"type" : weekendData,
                                      @"rule" : @"Weekend",
                                      @"fee" : self.weekendRateFee.text,
                                      };
                        weekendTaken = YES;
                    }
                    else                 if(!publicHolidayTaken)
                    {
                        tempDict = @{ @"id"   : @"",
                                      @"type" : publicHolidayData,
                                      @"rule" : @"Public Holiday",
                                      @"fee" : self.publicHolidayFee.text,
                                      };
                        publicHolidayTaken = YES;
                    }


                }
                
                [mutableList addObject:tempDict];
                //[mutableDict addEntriesFromDictionary:tempDict];
            }
            
            [mutableDict addEntriesFromDictionary:@{@"fees":mutableList}];
            
            MDDParkingSpot * newSpot = [[MDDParkingSpot alloc] initWithAttributes:[NSDictionary dictionaryWithDictionary:mutableDict]];
            [self.delegate editParkingSpot:newSpot andUpdateTo:self.parkingSpotObj];
            NSLog(@"edited a new parking spot");
            
            
            self.navigationItem.leftBarButtonItem = _backButton;
            
//            [self.navigationController popToRootViewControllerAnimated:YES];
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
    else
    {
        self.navigationItem.leftBarButtonItem = _cancelButton;
        
        [_editButton setStyle:UIBarButtonItemStyleDone];
        [_editButton setTitle:@"Done"];
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
							
- (IBAction)weekdaysRateChanged:(id)sender {
}
- (IBAction)weekendRateChanged:(id)sender {
}
- (IBAction)publicHolidayRateChanged:(id)sender {
}
@end
