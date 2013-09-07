//
//  MDDParkingSpot.h
//  Parking
//
//  Created by xun on 9/7/13.
//  Copyright (c) 2013 hackathon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface MDDParkingSpot : NSObject

@property (assign, nonatomic) NSUInteger id;
@property (strong, nonatomic) NSString* name ;
@property (assign, nonatomic) float lat ;
@property (assign, nonatomic) float lng ;
@property (strong, nonatomic) NSArray* fees ;


+ (void)pumpinDummyParkingSpotsWithBlock:(void (^)(NSArray *posts, NSError *error))block;

+ (void)nearestParkingSpotsWithBlock:(void (^)(NSArray *posts, NSError *error))block atCoordinate:(CLLocationCoordinate2D)coordinate withKeywords:(NSString*)searchQuery;

- (id)initWithAttributes:(NSDictionary*) attributes;

@end
