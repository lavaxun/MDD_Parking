//
//  MDDAppAPIClient.h
//  Parking
//
//  Created by xun on 9/7/13.
//  Copyright (c) 2013 hackathon. All rights reserved.
//

#import "AFHTTPClient.h"

@interface MDDAppAPIClient : AFHTTPClient

+ (MDDAppAPIClient *) sharedClient;

@end
