//
//  ZWVTweet.h
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/19/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ZWVUser.h"

@interface ZWVTweet : NSObject

@property (strong, nonatomic) NSString *createdDateString;
@property (strong, nonatomic) NSString *text;
@property (nonatomic) CLLocationCoordinate2D location;

@property (strong, nonatomic) ZWVUser *user;

- (instancetype)initWithDict:(NSDictionary *)jsonDict;

- (BOOL)hasLocation;

@end
