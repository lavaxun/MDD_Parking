//
//  MDDFee.h
//  Parking
//
//  Created by xun on 9/7/13.
//  Copyright (c) 2013 hackathon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDDFee : NSObject

@property (assign, nonatomic) NSUInteger id ;
@property (strong, nonatomic) NSString* rule ;
@property (strong, nonatomic) NSString* type ;
@property (assign, nonatomic) float fee ;

- (id)initWithAttributes:(NSDictionary*) attributes;

@end
