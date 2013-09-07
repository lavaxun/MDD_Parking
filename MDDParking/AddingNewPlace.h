//
//  AddingNewPlace.h
//  MDDParking
//
//  Created by xun on 9/7/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MDDParkingSpot;

@protocol AddingNewPlaceDelegate <NSObject>

- (void)addNewParkingSpot:(MDDParkingSpot*)place;

@end
