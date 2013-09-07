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
    _id = [[attributes valueForKeyPath:@"id"] integerValue];
    _type = [attributes valueForKeyPath:@"type"];
    _rule = [attributes valueForKeyPath:@"rule"];
    _fee = [[attributes valueForKeyPath:@"fee"] floatValue];
    
    return self;
}




@end
