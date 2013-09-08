//
//  MDDFee.m
//  Parking
//
//  Created by xun on 9/7/13.
//  Copyright (c) 2013 hackathon. All rights reserved.
//

#import "MDDFee.h"

@implementation MDDFee

@synthesize id = _id;
@synthesize type = _type;
@synthesize rule = _rule;
@synthesize fee = _fee;


- (id)initWithAttributes:(NSDictionary*) attributes
{
	NSLog(@"attributes ++ : %@, %@", attributes, [attributes class]);
  
  if([attributes isKindOfClass:[NSArray class]]){
	attributes = [(NSArray *)attributes lastObject];
  }
	  
  
  @try {
	_id = (NSUInteger)[attributes objectForKey:@"id"];
    _type = [attributes objectForKey:@"type"];
    _rule = [attributes objectForKey:@"rule"];
    _fee = [[attributes objectForKey:@"fee"] floatValue];
  }
  @catch (NSException *exception) {
    NSLog(@"Exception : %@", [exception reason]);
  }
  @finally {
    ;
  }

    
    return self;
}




@end
