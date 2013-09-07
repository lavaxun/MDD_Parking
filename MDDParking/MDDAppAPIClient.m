//
//  MDDAppAPIClient.m
//  Parking
//
//  Created by xun on 9/7/13.
//  Copyright (c) 2013 hackathon. All rights reserved.
//

#import "MDDAppAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "constant.h"

@implementation MDDAppAPIClient

+ (MDDAppAPIClient*) sharedClient
{
    static MDDAppAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[MDDAppAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if(!self)
    {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}



@end
