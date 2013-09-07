//
//  MDDParkingSpot.m
//  Parking
//
//  Created by xun on 9/7/13.
//  Copyright (c) 2013 hackathon. All rights reserved.
//

#import "MDDParkingSpot.h"
#import "MDDAppAPIClient.h"
#import "MDDFee.h"

@implementation MDDParkingSpot

@synthesize id = _id;
@synthesize name = _name;
@synthesize lat = _lat;
@synthesize lng = _lng;
@synthesize fees = _fees;


+ (void)pumpinDummyParkingSpotsWithBlock:(void (^)(NSArray *posts, NSError *error))block
{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"places-get"
                                                         ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    id JSON = [NSJSONSerialization JSONObjectWithData:data
                                              options:kNilOptions
                                                error:&error];
    
    if(error)
    {
        if(block)
        {
            block([NSArray array], error);
        }
    }
    else
    {
        NSArray *parkingSpotsFromResponse = [JSON valueForKeyPath:@"results"];
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[parkingSpotsFromResponse count]];
        for (NSDictionary *attributes in parkingSpotsFromResponse) {
            MDDParkingSpot *parkingSpot = [[MDDParkingSpot alloc] initWithAttributes:attributes];
            [mutablePosts addObject:parkingSpot];
        }
        
        if (block)
        {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    }
}


+ (void)nearestParkingSpotsWithBlock:(void (^)(NSArray *posts, NSError *error))block atCoordinate:(CLLocationCoordinate2D)coordinate withKeywords:(NSString*)searchQuery
{
    NSDictionary* parameters = @{
                                     @"lat"     :   @(coordinate.latitude),
                                     @"lng"     :   @(coordinate.longitude),
                                     @"keyword" :   searchQuery
                                 };
    
    [[MDDAppAPIClient sharedClient] getPath:@"places" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSArray *parkingSpotsFromResponse = [JSON valueForKeyPath:@"results"];
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[parkingSpotsFromResponse count]];
        for (NSDictionary *attributes in parkingSpotsFromResponse) {
            MDDParkingSpot *parkingSpot = [[MDDParkingSpot alloc] initWithAttributes:attributes];
            [mutablePosts addObject:parkingSpot];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}


- (id)initWithAttributes:(NSDictionary*) attributes
{
    _id = [[attributes valueForKeyPath:@"id"] integerValue];
    _name = [attributes valueForKeyPath:@"name"];
    _lat = [[attributes valueForKeyPath:@"lat"] floatValue];
    _lng = [[attributes valueForKeyPath:@"lat"] floatValue];
    
    NSArray* feesList = [attributes valueForKeyPath:@"fees"];
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:[feesList count]];
    
    for (NSDictionary *feeStructure in feesList) {
        MDDFee *parkingFee = [[MDDFee alloc] initWithAttributes:feeStructure];
        [mutableList addObject:parkingFee];
    }
    _fees = [NSArray arrayWithArray:mutableList];
    
    return self;
}


@end
