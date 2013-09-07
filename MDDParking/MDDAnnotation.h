//
//  MDDAnnotation.h
//  MDDParking
//
//  Created by Biranchi on 9/7/13.
//  Copyright (c) 2013 Xchanging. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MDDAnnotation : NSObject <MKAnnotation> {
  CLLocationCoordinate2D coordinate;
  id objectX;
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) id objectX;

@end
