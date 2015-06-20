//
//  ZWVUser.m
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/19/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import "ZWVUser.h"

NSString * const ZWVUserName = @"name";
NSString * const ZWVUserScreenName = @"screen_name";
NSString * const ZWVUserProfileImageURL = @"profile_image_url";

@implementation ZWVUser

- (instancetype)initWithDict:(NSDictionary *)jsonDict {
    if (!(self = [super init])) return nil;
    if (!jsonDict) return nil; // No dict, return nothing
    
    if (jsonDict[ZWVUserName]) {
        self.username = jsonDict[ZWVUserName];
    }
    if (jsonDict[ZWVUserScreenName]) {
        self.screenName = jsonDict[ZWVUserScreenName];
    }
    if (jsonDict[ZWVUserProfileImageURL]) {
        self.profileImageUrl = jsonDict[ZWVUserProfileImageURL];
    }
    
    return self;
}

@end
