//
//  ZWVTweet.m
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/19/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import "ZWVTweet.h"

NSString * const ZWVTweetAttributeUser = @"user";
NSString * const ZWVTweetAttributeText = @"text";
NSString * const ZWVTweetAttributeCoordinates = @"coordinates";

@implementation ZWVTweet

- (instancetype)initWithDict:(NSDictionary *)jsonDict {
    if (!(self = [super init])) return nil;
    if (!jsonDict) return nil; // No dict, return nothing
    
    if (jsonDict[ZWVTweetAttributeText]) {
        self.text = jsonDict[ZWVTweetAttributeText];
    }
    if (jsonDict[ZWVTweetAttributeCoordinates] && jsonDict[ZWVTweetAttributeCoordinates] != [NSNull null]) {
        NSArray *coordinateArray = jsonDict[ZWVTweetAttributeCoordinates][@"coordinates"];
        // Twitter puts longitude first, then latitude.
        NSNumber *longitude = (NSNumber *)[coordinateArray objectAtIndex:0];
        NSNumber *latitude = (NSNumber *)[coordinateArray objectAtIndex:1];
        self.location = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
    }
    if (jsonDict[ZWVTweetAttributeUser]) {
        self.user = [[ZWVUser alloc] initWithDict:jsonDict[ZWVTweetAttributeUser]];
    }
    
    return self;
}

@end
